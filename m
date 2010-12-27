Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab0L0VPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:15:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51089 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0L0VPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:15:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
Date: Mon, 27 Dec 2010 22:15:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-16-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
In-Reply-To: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012272215.52642.arnd@arndb.de>
X-Provags-ID: V02:K0:oIpoSj6LYD3c6aTUm7tRAfozc+iamBXhenjvO9TIubK
 MUtsSrP0+VwZeT3Qkn5cmpKuOagSOflg9t96n/iMeU0SKad7cl
 3KNgRNEkipdPCIzXWojbQZVcSXMI4vBfuiaYGxyXuPIkSI8yHe
 9+kXBmHhkXCqwRvPfFm7mzqbcMLeYgPk9kLx1UKp9cIMhsn4Mk
 5gWh3PAfE2tGvGqPzly1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 December 2010, Hillf Danton wrote:
> 
> Based upon high resolution timer and idea borrowed from semaphore,
> nano semaphore is created.
> 
> Nano semaphore provides finer time resolution depending on system
> configuration and capabilities.
> 
> Nano semaphore is not to replace semaphore, but used in application
> environments where nano seconds are required.
> 
> Three methods, nano_semaphore_try_down, nano_semaphore_down and
> nano_semaphore_up are implemented in a header file, and there is no
> corresponding C file since nano semaphore is not complex.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

There are very few users of real semaphores today, and we're trying to
get rid of them. It's not clear what your requirements are, since you
have not posted any new users of this, but instead of adding more
locking primitives, I would recommend changing one of the existing
ones (mutex, semaphore, rwsem) to have nanosecond timeouts instead
of jiffies.

The easiest way would certainly be to change the three users of
down_timeout() to use nanoseconds.

	Arnd
