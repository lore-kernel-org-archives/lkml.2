Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1HLXTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 19:19:52 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:60661 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab1HLXTu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 19:19:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110812213037.GA24803@google.com>
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-2-git-send-email-keshava_mgowda@ti.com> <1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-4-git-send-email-keshava_mgowda@ti.com> <1312899309-24067-5-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-6-git-send-email-keshava_mgowda@ti.com> <20110810163142.GA10156@google.com>
 <CAP05o4L+qn4K=jLx5Jo8WsG7LnU=VniQSR+fLc=RM5mW4kP1OQ@mail.gmail.com> <20110812213037.GA24803@google.com>
From: "Menon, Nishanth" <nm@ti.com>
Date: Fri, 12 Aug 2011 18:19:29 -0500
Message-ID: <CAOMWX4dUONED8_1KyooUu3Wn8PD+jT+XLRkkUhF9U-EvdUXi1w@mail.gmail.com>
Subject: Re: [PATCH 5/5 v4] mfd: omap: usb: Runtime PM support
To: Todd Poynor <toddpoynor@google.com>
Cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, khilman@ti.com, b-cousson@ti.com, paul@pwsan.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, vikram.pandita@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 16:30, Todd Poynor <toddpoynor@google.com> wrote:
> On Fri, Aug 12, 2011 at 12:20:21PM +0530, Munegowda, Keshava wrote:
>> On Wed, Aug 10, 2011 at 10:01 PM, Todd Poynor <toddpoynor@google.com> wrote:
>> >> @@ -913,12 +598,15 @@ static int usbhs_enable(struct device *dev)
>> >>                               (pdata->ehci_data->reset_gpio_port[1], 1);
>> >>       }
>> >>
>> >> -end_count:
>> >> -     omap->count++;
>> >> +     pm_runtime_put_sync(dev);
>> >>       spin_unlock_irqrestore(&omap->lock, flags);
>> >
>> > Is pm_runtime_irq_safe() needed (else I think runtime PM callbacks may
>> > re-enable IRQs... or there's the new *_suspend runtime PM calls that
>> > may avoid this)?
>>
>>  pm_runtime_irq_safe()  is not required; usbhs does not have a parent
>> and it is the parent driver of
>> ehci and ohci drivers.
>
> But the above expects IRQs to be disabled during the
> pm_runtime_put_sync, and synchronous calls can turn IRQs back on in
> rpm_idle:
>
>        if (callback) {
>                spin_unlock_irq(&dev->power.lock);
>
>                callback(dev);
>
> I see other folks who know this better than me are discussing USB run
> time PM and might_sleep contexts, so I'll note this concern and let
> others chime in if they think there's a real problem here.

It is rather easy with the following patch applied to pull this bug out!
https://patchwork.kernel.org/patch/1001572/

Regards,
Nishanth Menon
