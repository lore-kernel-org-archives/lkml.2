Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2IRJI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:08:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58700 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2IRJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:08:26 -0400
MIME-Version: 1.0
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A1820D5@SHSMSX101.ccr.corp.intel.com>
References: <1347972841.4312.2.camel@cliu38-desktop-build>
	<CAK7N6vqKp0Tcdr0CP4grq12C8-Oe05+uCEyos=mLMitwpet+Zw@mail.gmail.com>
	<27240C0AC20F114CBF8149A2696CBE4A181E13@SHSMSX101.ccr.corp.intel.com>
	<CAK7N6vosWH8HoWCyw_jjubL3CRYr-VRdxi1o9WevXd=stSQkcw@mail.gmail.com>
	<27240C0AC20F114CBF8149A2696CBE4A1820D5@SHSMSX101.ccr.corp.intel.com>
Date: Tue, 18 Sep 2012 14:38:26 +0530
Message-ID: <CAK7N6vqxnKbzm=iepjtOq0bZQhkFBjsWe6qhWnqOJtGxgKrT9w@mail.gmail.com>
Subject: Re: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
From: anish singh <anish198519851985@gmail.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 12:51 PM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
>> This comment might help.
>> kernel/irq/manage.c
>>
>>     } else if (new->handler == irq_default_primary_handler) {
>>
>>         /*
>>          * The interrupt was requested with handler = NULL, so
>>          * we use the default primary handler for it. But it
>>          * does not have the oneshot flag set. In combination
>>          * with level interrupts this is deadly, because the
>>          * default primary handler just wakes the thread, then
>>          * the irq lines is reenabled, but the device still
>>          * has the level irq asserted. Rinse and repeat....
>>          *
>>          * While this works for edge type interrupts, we play
>>          * it safe and reject unconditionally because we can't
>>          * say for sure which type this interrupt really
>>          * has. The type flags are unreliable as the
>>          * underlying chip implementation can override them.
>>          */
>
> This is not my case. My request_irq is as below:
> request_threaded_irq(drv_data->irq,
>                                           func1,
>                                           func2,
>                                           IRQF_SHARED|IRQS_ONESHOT ,
>                                           "AAAA",
>                                           drv_data);

I hope you are disabling the interrupt in your primary handler and returning
IRQ_WAKE_THREAD.
If yes then someone with experience in this interrupt handling code
can help you.
