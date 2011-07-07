Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1GGIvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:51:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33082 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab1GGIvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <E1QYhjj-0006Ne-Lp@tytso-glaptop>
References: <E1QYhjj-0006Ne-Lp@tytso-glaptop>
Date: Thu, 7 Jul 2011 12:51:40 +0400
Message-ID: <CA+X1aCRhsQCXmGFb=hjmDjPLxEX_H=8ZH=KTr=jRkRXZDmoMSg@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 update for 3.0
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

> Yongqiang Yang (1):
>      ext4: correct comments for ext4_free_blocks()

Any ideas why the patch fixing accounting of i_blocks in
ext4_free_blocks() didn't come to this set of changes?

The problem was that ext4_free_blocks() calls dquot_free_block() that,
in turn, calls inode_sub_bytes() decrementing i_blocks. This works
fine in most cases but the one: ext4_ext_map_blocks() might call
ext4_free_blocks (if ext4_ext_insert_extent failed) when allocated
blocks were only reserved, i.e. not accounted in i_blocks yet.

I recently re-run a simple test reproducing the problem and found out
that Linus' 3.0.0-rc6 is still affected by this problem. Does it make
sense to resend that patch to you?

Thanks,
Maxim
