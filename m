Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab1CAUBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:01:52 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54503 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1CAUBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EYDtmUAoSEWpzR4ZoPwJKViinJHHsA86uHoX2sUX71zS+59ZCgNa1uCO2flBrZC5W/
         KcTGFLznuh9V/dK01TkixIiPUY7bV+xgrDPe4Ioyi3OMKQmW9d6EwAu0kuU9CO/+EcrL
         ElO4IUpv8KOHB2RQ6b0iK/KnK4ry6bDRygOS0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1103011448430.2034-100000@iolanthe.rowland.org>
References: <b01ca43311e25bf24c6e60e9f6d6d7b91ae3a130.1298820826.git.tardyp@gmail.com>
	<Pine.LNX.4.44L0.1103011448430.2034-100000@iolanthe.rowland.org>
Date: Tue, 1 Mar 2011 21:01:50 +0100
Message-ID: <AANLkTikt1r3j99_ub0ce3_3snjoDXvR2+x6RxcjGfMK8@mail.gmail.com>
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

>> +     if (pm_runtime_suspended()) {
>> +             host->waking_up = 1;
>> +             /* Note that we disable temporarly the interrupt until we do the
>> +              * resume. If we don't then we'll get constantly interrupted
>> +              * until we actually resume.
>> +              *
>> +              * as the irq is shared, this might not be very friendly to our
>> +              * irq sharers but the pm_runtime workqueue should really be
>> +              * called soon.
>
> Instead of disabling the IRQ, would it be possible to tell the device
> to stop generating an interrupt request?

Well, the device is power gated, so any access to it will cause a bus
timeout (depending of the platform)

>> +              */
>> +             disable_irq_nosync(irq);
>> +             pm_runtime_get(host->mmc->parent);
>
> Does this pm_runtime_get() have a corresponding pm_runtime_put()?  I
> didn't notice one anywhere.
oups, forgot to add the corresponding snippet in sdhci_runtime_resume:
if (host->waking_up) {
    pm_runtime_put();
    host->waking_up = 0;
}

>>
>
> Surely this doesn't belong in the patch.
yep sorry, I should stop doing git commit -a...

Pierre
