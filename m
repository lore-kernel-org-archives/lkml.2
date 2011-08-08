Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1HHTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:44:29 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:51585 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868Ab1HHTo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:44:28 -0400
X-Greylist: delayed 8708 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Aug 2011 15:44:28 EDT
Date: Mon, 8 Aug 2011 19:00:46 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: AT91SAM9261EK kit is broken, commit bd60299 has broken it
Message-ID: <20110808170046.GA22213@game.jcrosoft.org>
References: <CANqCtQKpAydgXEzs6OzsDDBM_9yVBaGjT++DBq-NKOUH+ssLGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqCtQKpAydgXEzs6OzsDDBM_9yVBaGjT++DBq-NKOUH+ssLGA@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1915155742658833251
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -210
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvjedrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehlihhnuhigucdlqddutddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

	I'm taking a look on it

Best Regads,
J.
On 23:27 Sat 06 Aug     , Remy Bohmer wrote:
> Hi Jean-Christophe,
> 
> Currently the Atmel AT91SAM9261-EK kit is broken within Linux 3.0,
> 3.01 and latest git.
> 
> These are the symptoms:
> * Booting stops if LCD driver is enabled in the kernel. It stops
> within the probe of the LCD driver. (at a msleep(10))
> * schedule_timeout is broken.
> * The jiffies based sched_clock does not run properly and stalls
> during boot, before the LCD driver is being initialised. (You can see
> this with printk-timestamps enabled)
> * When LCD driver disabled, boards boots up to a prompt, but every
> tool (e.g. 'top') that does a nanosleep syscall stays blocked in the
> kernel.
> 
> After bisecting the tree searching for the offending commit, I came to
> the following patch, after reverting it in mainline, everything works
> again as normal. I do not see immediately what is wrong with this
> commit, do you have an idea? Otherwise I will dig deeper in this
> commit...
> 
> bd60299594fb1d28ae66563c9e76a0b89b0412cf is the first bad commit
> commit bd60299594fb1d28ae66563c9e76a0b89b0412cf
> Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Date:   Wed Feb 2 07:27:07 2011 +0100
> 
>     at91: switch to CLKDEV_LOOKUP
> 
>     we do not change the clock naming convention so does not need to switch
>     the AVR32 yet
> 
>     Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>     Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>     Cc: Patrice Vilchez <patrice.vilchez@atmel.com>
> 
> Kind regards,
> 
> Remy
