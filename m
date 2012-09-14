Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2INIv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:51:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40569 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2INIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:51:54 -0400
MIME-Version: 1.0
In-Reply-To: <87txv2ndhh.fsf@devron.myhome.or.jp>
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
	<87txv2ndhh.fsf@devron.myhome.or.jp>
Date: Fri, 14 Sep 2012 17:51:52 +0900
Message-ID: <CAKYAXd8BP8mFoVTQW3bvNTfVoCA1L9zdP4_hG7Z_hkKcJC-1tA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/14, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
>
>>> > Current -mm means the best-effort work only if inode cache is not
>>> > evicted.  I.e. if there is no inode cache anymore on server, server
>>> > would return ESTALE. So I guess the behavior would not be stable
>>> > relatively.
>>> Hi OGAWA.
>>> Sorry for late response.
>>> Okay, I will resend patchset include your suggeston.(-o nfs=2)
>>> Do you mind adding busy list patch to avoid unlink issue ?
>>> And in case of rename, FAT retrun EBUSY while opening file.
>>> We can limit only rename.
>>
>> The server doesn't necessarily know whether a client has the file open,
>> so does that really help?
>
> If you are assuming to do rename() somehow, it would not be true. And if
> so, you might want to rethink about the patch. (btw, I'm not thinking
> deeply yet though, I guess we have to limit unlink() too)
Hi OGAWA.
Sorry, There are some unclear things in unlink solution.
When we tested before, That did really help.
So, we will check unlink solution more and after fully convinced will
send in separate patch later with updates in changelog of patch when
enabling write support..
>
> Well, anyway, I'd like to see stable/clean read-only support at first.
> (with new nfs option, and with MS_RDONLY).  After that, we can
> enable write support.
Okay, I will send stable ino patch(read-only) soon.

Thanks a lot!
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
