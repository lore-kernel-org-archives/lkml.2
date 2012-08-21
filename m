Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2HUK6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:58:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64080 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2HUK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <874nnwiw67.fsf@devron.myhome.or.jp>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
	<87pq6op9zz.fsf@devron.myhome.or.jp>
	<CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
	<20120820205231.GG5779@fieldses.org>
	<CAKYAXd8fkV5x454vtXvwM6LN3Hb2dLgemhJdNFKyxnwweNq75A@mail.gmail.com>
	<874nnwiw67.fsf@devron.myhome.or.jp>
Date: Tue, 21 Aug 2012 19:58:35 +0900
Message-ID: <CAKYAXd_kJtK85iabM=-ObJSC2qo36mkVsQ1VhaYk3WBNKn9uhg@mail.gmail.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/21, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
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
Sorry for my mistake. You're right.
I am looking up other solution.
Thanks
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
