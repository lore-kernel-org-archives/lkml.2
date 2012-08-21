Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2HUGlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:41:45 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58733 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2HUGll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:41:41 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
	<87pq6op9zz.fsf@devron.myhome.or.jp>
	<CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
	<20120820205231.GG5779@fieldses.org>
	<CAKYAXd8fkV5x454vtXvwM6LN3Hb2dLgemhJdNFKyxnwweNq75A@mail.gmail.com>
Date: Tue, 21 Aug 2012 15:41:36 +0900
In-Reply-To: <CAKYAXd8fkV5x454vtXvwM6LN3Hb2dLgemhJdNFKyxnwweNq75A@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 21 Aug 2012 14:19:46 +0900")
Message-ID: <874nnwiw67.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> And.. Hi Ogawa.
> I checked other filesystem about unlink - inode issue. but I found
> Ext4 have same issue.
> Although other filesysm is having this issue, Can we think It could be
> only FAT issue ?

(I assume this issue == orphaned inode issue).

ext* doesn't have this issue. If ext* made orphaned inode, ext* doesn't
delete inode from inode table until calling iput() from last referencer.

In FAT case, FAT inode is embedded into dir entry. So, if unlinked inode
(then orphaned inode is detached (fat_detach())), FAT deletes inode (dir
entry) from dir.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
