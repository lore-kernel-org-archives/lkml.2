Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0JUJD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:03:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0JUJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:03:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Date: Thu, 21 Oct 2010 11:04:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <201010192308.02018.arnd@arndb.de> <AANLkTikz-_qhjygzek4tR0CtDLih3ZQyy1mPKnXAiOiV@mail.gmail.com>
In-Reply-To: <AANLkTikz-_qhjygzek4tR0CtDLih3ZQyy1mPKnXAiOiV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211104.28555.arnd@arndb.de>
X-Provags-ID: V02:K0:qF/h02VlW12xwsZkNeXrX7nMZQYGGF4vE7lnWDizxyn
 5dMrYMZ/amjheBKrF7lUVeYKTl1qW2XOUJYJTrZ17TgeBH+2G0
 jWGPPkSJI6svUEkR3563Dp0AvhwWMnUz0YJ5Mlyh2o/vN4ahtJ
 bqnG9mWOfEywt39O6yg9k0namF5xL6yl+2dC+pgBqYVYcm10y1
 S1tdpozS3e/sIXnAFBEDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010, Ohad Ben-Cohen wrote:
> This sounds like adding a set of API that resembles spin_{unlock,lock}_irq.
> 
> My gut feeling here is that while this may be useful and simple at
> certain places, it is somewhat error prone; a driver which would
> erroneously use this at the wrong place will end up enabling
> interrupts where it really shouldn't.
> 
> Don't you feel that proving a simple spin_lock_irqsave-like API is
> actually safer and less error prone ?
> 
> I guess that is one of the reasons why spin_lock_irqsave is much more
> popular than spin_lock_irq - people just know it will never screw up.

People can screw that up in different ways, e.g.

	spin_lock_irqsave(&lock_a, flags);
	spin_lock_irqsave(&lock_b, flags); /* overwrites flags */

	spin_lock_irqrestore(&lock_b, flags);
	spin_lock_irqrestore(&lock_a, flags); /* still disabled! */

I use the presence of spin_lock_irqsave in driver code as an indication
of whether the author had any clue about locking. Most experienced
coders use the right version intuitively, while beginners often just
use _irqsave because they didn't understand the API and they were told
that using this is safe.

	Arnd
