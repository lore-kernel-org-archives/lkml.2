Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1IHN6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:58:22 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39671 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932879Ab1IHN6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:58:21 -0400
X-Sasl-enc: ZW/nlYjBs7fdkMtXu4Te+ivXwBORFdmIpibNfS187Lu8 1315490300
Message-ID: <4E68CA15.8000504@ladisch.de>
Date: Thu, 08 Sep 2011 15:58:45 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
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
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-3-git-send-email-yong.zhang0@gmail.com> <4E689E9A.8000407@ladisch.de> <20110908133700.GB2310@zhy>
In-Reply-To: <20110908133700.GB2310@zhy>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> On Thu, Sep 08, 2011 at 12:53:14PM +0200, Clemens Ladisch wrote:
>> Yong Zhang wrote:
>> > Now snd_mpu401_uart_new() parameter 'irq_flags' take two role
>> > in it: one is the condition to request_irq and the other is
>> > the real irq_flags which will be transfered to request_irq().
>> > 
>> > So add another parameter 'want_irq' to take the role of the
>> > first one, this will make it easy to remove IRQF_DISABLED.
>> 
>> Please note that the irq number is also intended to pass this
>> information:
> 
> Yes.
> 
> this is a bit subtle:
>  * @irq: the irq number, -1 if no interrupt for mpu
>     
> This semantic of 'irq' is kept by the callers IMHO.
> 
>  * @irq_flags: the irq request flags (SA_XXX), 0 if irq was already reserved.
> 
> So irq_flags has other meaning--if the irq is already reserved.
> Maybe my imprecise description make some kind of misunderstanding.

The wording is just sloppy.

> BTW, I'm not familiar with mpu401, so maybe I'm missing something here.

The MPU-401 in UART mode is a very simple and stupid MIDI interface,
which is used on very many sound cards.  Depending on the actual
hardware implementation, it gets its own interrupt which may be
exclusive or sharable, or it is integrated into the interrupt handling
of the main sound card which means that the sound driver has to call the
mpu401 interrupt handler explicitly.

Here, "no interrupt" and "already reserved" actually mean the same thing,
i.e., that the interrupt handling is the responsibility of some other
driver.


Regards,
Clemens
