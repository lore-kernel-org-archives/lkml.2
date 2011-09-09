Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1IIBby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:31:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62696 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab1IIBbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:31:52 -0400
Date: Fri, 9 Sep 2011 09:31:43 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Andreas Mohr <andi@lisas.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Julia Lawall <julia@diku.dk>, Ondrej Zary <linux@rainbow-software.org>,
        Dan Carpenter <error27@gmail.com>, Joe Perches <joe@perches.com>,
        alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
Message-ID: <20110909013143.GB18249@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-3-git-send-email-yong.zhang0@gmail.com>
 <4E689E9A.8000407@ladisch.de>
 <20110908133700.GB2310@zhy>
 <4E68CA15.8000504@ladisch.de>
 <20110908144519.GB3069@zhy>
 <4E69253F.3090705@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E69253F.3090705@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 10:27:43PM +0200, Clemens Ladisch wrote:
> Yong Zhang wrote:
> > On Thu, Sep 08, 2011 at 03:58:45PM +0200, Clemens Ladisch wrote:
> > > ...
> > > Here, "no interrupt" and "already reserved" actually mean the same thing,
> > > i.e., that the interrupt handling is the responsibility of some other
> > > driver.
> 
> Sorry, after checking the code, I've realized that my description was
> wrong.  irq_flags==0 ("already reserved") means that snd_mpu401_uart_new
> should not try to allocate the interrupt, while irq==-1 ("no interrupt")
> means that the device never issues mpu401 interrupts, so that the mpu401
> code must use a timer to poll the device.
> 
> I'll write a patch that changes this function so that irq<0 means
> "already reserved", and that "no interrupt" gets another bit in the
> info_flags parameter.

Sounds good.

So my patch will be based on yours; or if you have other plan,
how about let's take this patch as a temporary workaroud?

Anyway, you decide it :)

Thanks,
Yong
