Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2IXEjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:39:44 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42212 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2IXEjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:39:43 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
	<87lig28fak.fsf@devron.myhome.or.jp>
	<CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
Date: Mon, 24 Sep 2012 13:39:35 +0900
In-Reply-To: <CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 24 Sep 2012 13:11:11 +0900")
Message-ID: <87ipb45914.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> I think we don't need this. Because FH and ino is not necessary to have
>> relation.
>>
>> Can we re-introduce ->encode_fh() handler, and export i_pos again?  With
>> this, I think we can get i_pos correctly. Otherwise, ino may not contain
>> all bits of i_pos.
> I already tried to fix this issue using encode_fh without stable ino before.
> But I reached conclusion that we should use stable inode number.
>
> e.g. If we rebuild inode number using i_pos of fh, inode number is
> changed by i_unique.
> And It is not match with inode number of FH on NFS client. So estale
> error will happen.

What is problem if i_ino + i_generation is not match? I think, even if
those didn't match, i_pos in FH should resolve issue, no?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
