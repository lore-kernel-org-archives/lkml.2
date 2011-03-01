Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab1CAUsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:48:40 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52627 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1CAUsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:48:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YCz9+j9FsSHvSDZvKWs4ki754euFBjaly+1CXturjDimIN1YgtkgOZ33AITJ5mQRdc
         0Zf+OxNpfJQXYPZTKi2Ka0WsNRJL4/HhlNZBEBe9jU/FT+9jETy+B4LZCAhXezqj4BH4
         B1SOdDhIVZ189cgHoRx5ksypzp3IJvj8QpxcQ=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1103011525040.2034-100000@iolanthe.rowland.org>
References: <AANLkTikt1r3j99_ub0ce3_3snjoDXvR2+x6RxcjGfMK8@mail.gmail.com>
	<Pine.LNX.4.44L0.1103011525040.2034-100000@iolanthe.rowland.org>
Date: Tue, 1 Mar 2011 21:48:37 +0100
Message-ID: <AANLkTi=nWXad7WMRYxu7cvC478qy7ptpotR4K_ATNt_J@mail.gmail.com>
Subject: Re: [linux-pm] [RFC, PATCHv3 3/3] mmc: sdhci: handle wake-up from runtime_pm
From: Pierre Tardy <tardyp@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 9:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 1 Mar 2011, Pierre Tardy wrote:
>
>> >> +     if (pm_runtime_suspended()) {
>> >> +             host->waking_up = 1;
>> >> +             /* Note that we disable temporarly the interrupt until we do the
>> >> +              * resume. If we don't then we'll get constantly interrupted
>> >> +              * until we actually resume.
>> >> +              *
>> >> +              * as the irq is shared, this might not be very friendly to our
>> >> +              * irq sharers but the pm_runtime workqueue should really be
>> >> +              * called soon.
>> >
>> > Instead of disabling the IRQ, would it be possible to tell the device
>> > to stop generating an interrupt request?
>>
>> Well, the device is power gated, so any access to it will cause a bus
>> timeout (depending of the platform)
>
> But could you gate the power back on and then turn off the interrupt
> request?
That's the role of runtime_resume... On some platform, this may need
up to sending some SPI commands to the PMIC, to get those power rails
back on.
Something that you cannot do in interrupt context.

>
> It seems like a foolish design to have an interrupt request that can't
> be turned off by an interrupt handler.
It's what we have for now ( looks like I need to go back to my system
architects to see if we can change that...)

Alan,
thanks for all this feedback. I have now a much more clear view on how
this is working on ACPI, I'll try to see how we can mimic this
behaviour on intel_mid.
