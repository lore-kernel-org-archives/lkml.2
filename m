Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1DSQKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:10:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1DSQKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:10:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality V2
Date: Tue, 19 Apr 2011 18:10:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, ohad@wizery.com,
        linux-kernel@vger.kernel.org
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org> <201104172239.57362.arnd@arndb.de> <4DADB2F1.1080405@linaro.org>
In-Reply-To: <4DADB2F1.1080405@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191810.18170.arnd@arndb.de>
X-Provags-ID: V02:K0:K8i1T/mB6aExqcqfS6by7pkA9m6mLwqr0oHBzN9J+dh
 bLjCGMq651FMmc0f+BEqQYD33Q8uFCKGv+08UMPA3cL+hfukW3
 2B2xfqADAY0TpT8ggB+L389p4k6nErxEt67kZiKsz1+BQzeGMz
 NeqTFpLDd3EVr0OnHferpC1FdWvaQDYJd/pRSlesI9eVtyqhoX
 eB0BWYQBsoyDPpyi0CIEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, Mathieu Poirier wrote:
> > One more thing I just noticed: the hwspinlock_internal.h file defines
> > the hwspinlock->id field as "a global, unique, system-wide, index of
> > the lock", but the u8500 hsem just sets it to an integer starting
> > at zero. If there are multiple devices providing hwspinlocks in the
> > same system, that cannot work.
> >
> I have to admit I'm not sure of what your asking here.  Hwspinlocks 
> should be administered by only one entity and this is what this driver 
> is doing.
> 
> Please get back to me with a clarification.

You could have a system with multiple instances of the hardware block
that holds your spinlock. I've seen SMP systems that basically take
multiple SOCs and put them into a common address space.

More importantly, there could be a device on an external bus that also
provides a hwspinlock. The API can deal with this, but your driver will
conflict with any other driver trying to do the same.

	Arnd
