Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1IHXcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:32:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55213 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596Ab1IHXcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:32:41 -0400
X-Sasl-enc: TZrjivTtowLg3w7FJjztErLYH2hbUv0hL9ZdriV4EPWg 1315513688
Message-ID: <4E69253F.3090705@ladisch.de>
Date: Thu, 08 Sep 2011 22:27:43 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090820)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Andreas Mohr <andi@lisas.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Julia Lawall <julia@diku.dk>, Ondrej Zary <linux@rainbow-software.org>,
        Dan Carpenter <error27@gmail.com>, Joe Perches <joe@perches.com>,
        alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-3-git-send-email-yong.zhang0@gmail.com> <4E689E9A.8000407@ladisch.de> <20110908133700.GB2310@zhy> <4E68CA15.8000504@ladisch.de> <20110908144519.GB3069@zhy>
In-Reply-To: <20110908144519.GB3069@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> On Thu, Sep 08, 2011 at 03:58:45PM +0200, Clemens Ladisch wrote:
> > ...
> > Here, "no interrupt" and "already reserved" actually mean the same thing,
> > i.e., that the interrupt handling is the responsibility of some other
> > driver.

Sorry, after checking the code, I've realized that my description was
wrong.  irq_flags==0 ("already reserved") means that snd_mpu401_uart_new
should not try to allocate the interrupt, while irq==-1 ("no interrupt")
means that the device never issues mpu401 interrupts, so that the mpu401
code must use a timer to poll the device.

I'll write a patch that changes this function so that irq<0 means
"already reserved", and that "no interrupt" gets another bit in the
info_flags parameter.


Regards,
Clemens
