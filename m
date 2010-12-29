Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0L2LsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 06:48:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0L2LsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 06:48:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH v0] add nano semaphore in kernel
Date: Wed, 29 Dec 2010 12:47:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com> <201012272215.52642.arnd@arndb.de> <1293551490.24601.10.camel@m0nster>
In-Reply-To: <1293551490.24601.10.camel@m0nster>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291247.27663.arnd@arndb.de>
X-Provags-ID: V02:K0:Hp8tK0sustM5RMCHxNtbW+c0fenvGp4vl/kLryeuaXt
 yNGN2ILIih14ofTYZQKQjdCE3oCnwRP3vLk7dL0jKFb/i2+akc
 DfRp1Ln2++7fHDgIe5MhcMENqWkKWSQ4a3SmyyLz6djJ5ZU7GF
 cjSg9otl7YNp3BTTru6yFTHxmIzvEf6OX8ylr/fqQ4Dags1r1u
 e7Ou9kfQ8SXGajGapWNGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 December 2010 16:51:30 Daniel Walker wrote:
> We for sure don't want new semaphores, or new semaphore usage in the
> kernel ..

Yes. I once even tried unifying the semaphore and rwsem implementation,
but gave up on that for a number of reasons.

> It should also be noted that the rtmutex (kernel/rtmutex.c) already has
> this capability. Although I don't think you can use an rtmutex from
> inside the kernel.

I wasn't aware we had already grown another one ;-)

AFAICT, you can only use it inside of the kernel, but it's very
specific and I wouldn't recommend using it unless a regular mutex
cannot be used for some reason. The only user besides the futex
code seems to be the i2c layer at this moment.

> If you really want this you should look into the rtmutex, and the
> regular mutex API's .

If Hillf relies on counting semaphores, that won't work, but very
few such users exist in code outside of textbooks.

	Arnd
