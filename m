Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1BVV05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:26:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55031 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1BVV0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:26:55 -0500
MIME-Version: 1.0
In-Reply-To: <1298404696.9215.47.camel@work-vm>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>
 <1298362178.4222.57.camel@work-vm> <AANLkTinMPnJj+ca+=ujU=5rhK3Nh0qrFGe955zZWjYaf@mail.gmail.com>
 <1298403310.9215.26.camel@work-vm> <20110222195143.GC31611@opensource.wolfsonmicro.com>
 <1298404696.9215.47.camel@work-vm>
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Tue, 22 Feb 2011 18:26:34 -0300
Message-ID: <AANLkTi=9iuFStoKZ1VZf0AMno=2LfyWqppPEReUFkEC2@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup rtc_class_ops->read_alarm()
To: john stultz <johnstul@us.ibm.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 16:58, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2011-02-22 at 19:51 +0000, Mark Brown wrote:
>> On Tue, Feb 22, 2011 at 11:35:10AM -0800, john stultz wrote:
>>
>> > Yea. The way I thought about it originally was that you can set an alarm
>> > and that alarm will fire if the machine is on, suspended or even in some
>> > cases off.  Then, when the machine is booted (system reset), the state
>> > of the RTC's alarm should not be trusted.
>>
>> > Your description of the AIE/UIE having random values aligns with that
>> > intuition.
>>
>> This seems rather worrying - it sounds like it might mean that the
>> device might come up firing spuriously which doesn't seem terribly
>> clever.
>
> Well, in those known cases the driver should initalize the irq modes to
> be off.

Just a correction to my post, it was not AIE/UIE with ramdom values,
it was an alarm or update interrupt pending bit in the status register
(RTSR) that woke up set after reboot, even before interrupts were
enabled. In this case, the device would wake up with an interrupt
pending. The interrupt routine would not clear an interrupt that was
not enabled and that lead to an infinite loop of interrupts.

Regards,
Marcelo.
