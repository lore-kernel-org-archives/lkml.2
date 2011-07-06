Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1GFGJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:09:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48526 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1GFGJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:09:03 -0400
MIME-Version: 1.0
Date: Wed, 6 Jul 2011 15:09:01 +0900
X-Google-Sender-Auth: AiwNff_5LDreBP-xcoCsqjVI-II
Message-ID: <CAH9JG2Xp_u-46x8bf2Uq-9FREZyYhcP3E7H+MsSoFVrWpyLrtA@mail.gmail.com>
Subject: ext4: why init the unused block group at batched discard?
From: Kyungmin Park <kmpark@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

During code review batched discard support at ext4. I wonder why do
you init the uninitialized block group during batched discard.
As you know uninitialized block group mean that there's no operation
at these blocks.
So no need to trim it at all.

How do you think?

int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
{
        ...

        for (group = first_group; group <= last_group; group++) {
                grp = ext4_get_group_info(sb, group);
                /* We only do this if the grp has never been initialized */
                if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
                        ret = ext4_mb_init_group(sb, group);
                        if (ret)
                                break;
                }
        ...
        }
        ...
}

Thank you,
Kyungmin Park
