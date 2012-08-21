Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab2HUVML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:12:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47167 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab2HUVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <874nnwiw67.fsf@devron.myhome.or.jp>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
	<87pq6op9zz.fsf@devron.myhome.or.jp>
	<CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
	<20120820205231.GG5779@fieldses.org>
	<CAKYAXd8fkV5x454vtXvwM6LN3Hb2dLgemhJdNFKyxnwweNq75A@mail.gmail.com>
	<874nnwiw67.fsf@devron.myhome.or.jp>
Date: Tue, 21 Aug 2012 23:11:55 +0200
Message-ID: <CAE2SPAan64zL2Fy3VDHetewHbV71cuHhkEd3AoTJEzeBG=FyEA@mail.gmail.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 8:41 AM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> And.. Hi Ogawa.
>> I checked other filesystem about unlink - inode issue. but I found
>> Ext4 have same issue.
>> Although other filesysm is having this issue, Can we think It could be
>> only FAT issue ?
>
> (I assume this issue == orphaned inode issue).
>
> ext* doesn't have this issue. If ext* made orphaned inode, ext* doesn't
> delete inode from inode table until calling iput() from last referencer.
>
> In FAT case, FAT inode is embedded into dir entry. So, if unlinked inode
> (then orphaned inode is detached (fat_detach())), FAT deletes inode (dir
> entry) from dir.

Could be possible to not delete it?

I mean using a special value for this case, mark delete (using 0xe5 as
first character) but put for instance creation month to be egal to 15.

This entry will be therefore be keep and not overwritten by successive
file creation.

At least this solve the file deleted issue (not the rename issue unfortunatly)

Bastien
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
