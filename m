Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1DQUkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:40:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65366 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1DQUkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:40:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality V2
Date: Sun, 17 Apr 2011 22:39:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>, ohad@wizery.com,
        linus.walleij@stericsson.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org> <201104121946.01618.arnd@arndb.de> <4DA4A44D.5020208@linaro.org>
In-Reply-To: <4DA4A44D.5020208@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172239.57362.arnd@arndb.de>
X-Provags-ID: V02:K0:8ndDP0/0mX81zFOTa6xpKAjJXX8LHL1OSLyRkTtaP+X
 54Q4RUyA0dhMpU2r30MCnBNCCP5cxBPI0mE6N24poYpav1cs6C
 r/GW3rO5xSH3Sv5E2SUxQKKRpwhofP7NeTPUm9k5cND4Y8TLMH
 pdNdsg7geAycBVUXK4oHZzqpQ2RSW+5OzD4px6OTXsUdITjuNK
 RwaUBAV8SLH0sym9e5SnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 April 2011, Mathieu Poirier wrote:
> > struct u8500_hsem_state {
> >       void __iomem *io_base;
> >       struct u8500_hsem hsem[U8500_MAX_SEMAPHORE];
> > }
> I don't see the real advantage in doing a single allocation - the 
> dynamic allocation method is also used in 'omap_hwspinlock.c'.  Is 
> modification mandatory to get the driver accepted ?

Not strictly required, but somewhat cleaner IMHO. If you have a good
reason for splitting the allocations, just document that clearly.

One more thing I just noticed: the hwspinlock_internal.h file defines
the hwspinlock->id field as "a global, unique, system-wide, index of
the lock", but the u8500 hsem just sets it to an integer starting
at zero. If there are multiple devices providing hwspinlocks in the
same system, that cannot work.

	Arnd
