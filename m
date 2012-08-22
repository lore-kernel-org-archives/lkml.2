Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2HVGOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:14:34 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:59067 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2HVGOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:14:32 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
	<87pq6op9zz.fsf@devron.myhome.or.jp>
	<CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
	<20120820205231.GG5779@fieldses.org>
	<CAKYAXd8fkV5x454vtXvwM6LN3Hb2dLgemhJdNFKyxnwweNq75A@mail.gmail.com>
	<874nnwiw67.fsf@devron.myhome.or.jp>
	<CAE2SPAan64zL2Fy3VDHetewHbV71cuHhkEd3AoTJEzeBG=FyEA@mail.gmail.com>
Date: Wed, 22 Aug 2012 15:14:28 +0900
In-Reply-To: <CAE2SPAan64zL2Fy3VDHetewHbV71cuHhkEd3AoTJEzeBG=FyEA@mail.gmail.com>
	(Bastien ROUCARIES's message of "Tue, 21 Aug 2012 23:11:55 +0200")
Message-ID: <87628bjvwb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien ROUCARIES <roucaries.bastien@gmail.com> writes:

>> (I assume this issue == orphaned inode issue).
>>
>> ext* doesn't have this issue. If ext* made orphaned inode, ext* doesn't
>> delete inode from inode table until calling iput() from last referencer.
>>
>> In FAT case, FAT inode is embedded into dir entry. So, if unlinked inode
>> (then orphaned inode is detached (fat_detach())), FAT deletes inode (dir
>> entry) from dir.
>
> Could be possible to not delete it?

It should be deletable on linux. Because many apps are assuming
orphaned inode works.

> I mean using a special value for this case, mark delete (using 0xe5 as
> first character) but put for instance creation month to be egal to 15.
>
> This entry will be therefore be keep and not overwritten by successive
> file creation.
>
> At least this solve the file deleted issue (not the rename issue unfortunatly)

I assume you are saying to prevent creation somehow, not deletion. Yes, it
is possible though, it would give additional overhead and complexity to us.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
