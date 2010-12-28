Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0L1Pvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:51:40 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15022 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0L1Pvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:51:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6209"; a="68509824"
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Daniel Walker <dwalker@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201012272215.52642.arnd@arndb.de>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	 <201012272215.52642.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 07:51:30 -0800
Message-ID: <1293551490.24601.10.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 22:15 +0100, Arnd Bergmann wrote:
> On Sunday 26 December 2010, Hillf Danton wrote:
> > 
> > Based upon high resolution timer and idea borrowed from semaphore,
> > nano semaphore is created.
> > 
> > Nano semaphore provides finer time resolution depending on system
> > configuration and capabilities.
> > 
> > Nano semaphore is not to replace semaphore, but used in application
> > environments where nano seconds are required.
> > 
> > Three methods, nano_semaphore_try_down, nano_semaphore_down and
> > nano_semaphore_up are implemented in a header file, and there is no
> > corresponding C file since nano semaphore is not complex.
> > 
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> There are very few users of real semaphores today, and we're trying to
> get rid of them. It's not clear what your requirements are, since you
> have not posted any new users of this, but instead of adding more
> locking primitives, I would recommend changing one of the existing
> ones (mutex, semaphore, rwsem) to have nanosecond timeouts instead
> of jiffies.
> 
> The easiest way would certainly be to change the three users of
> down_timeout() to use nanoseconds.

We for sure don't want new semaphores, or new semaphore usage in the
kernel ..

It should also be noted that the rtmutex (kernel/rtmutex.c) already has
this capability. Although I don't think you can use an rtmutex from
inside the kernel.

If you really want this you should look into the rtmutex, and the
regular mutex API's .

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


