Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab2IMPef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:34:35 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38436 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2IMPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:34:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <87vcfjfa14.fsf@devron.myhome.or.jp>
	<20120912171128.GG3009@fieldses.org>
	<87r4q7f8fw.fsf@devron.myhome.or.jp>
	<20120912174556.GH3009@fieldses.org>
	<87ipbjf54f.fsf@devron.myhome.or.jp>
	<CAKYAXd-5CQrE=232NKk9pRjzP3q8OBryeLt9mH==f=zrKdjzNg@mail.gmail.com>
	<87txv2cog1.fsf@devron.myhome.or.jp>
	<20120913112024.GA24684@fieldses.org>
	<87ehm6p15v.fsf@devron.myhome.or.jp>
	<CAKYAXd9a0WjZXyX43crqSKFZirE0eShk=OZNmyACn04vTrQ33A@mail.gmail.com>
	<20120913144602.GD24684@fieldses.org>
Date: Fri, 14 Sep 2012 00:34:18 +0900
In-Reply-To: <20120913144602.GD24684@fieldses.org> (J. Bruce Fields's message
	of "Thu, 13 Sep 2012 10:46:02 -0400")
Message-ID: <87txv2ndhh.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

>> > Current -mm means the best-effort work only if inode cache is not
>> > evicted.  I.e. if there is no inode cache anymore on server, server
>> > would return ESTALE. So I guess the behavior would not be stable
>> > relatively.
>> Hi OGAWA.
>> Sorry for late response.
>> Okay, I will resend patchset include your suggeston.(-o nfs=2)
>> Do you mind adding busy list patch to avoid unlink issue ?
>> And in case of rename, FAT retrun EBUSY while opening file.
>> We can limit only rename.
>
> The server doesn't necessarily know whether a client has the file open,
> so does that really help?

If you are assuming to do rename() somehow, it would not be true. And if
so, you might want to rethink about the patch. (btw, I'm not thinking
deeply yet though, I guess we have to limit unlink() too)

Well, anyway, I'd like to see stable/clean read-only support at first.
(with new nfs option, and with MS_RDONLY).  After that, we can
enable write support.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
