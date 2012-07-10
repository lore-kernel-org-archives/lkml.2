Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab2GJEEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 00:04:40 -0400
Received: from void.printf.net ([89.145.121.20]:42311 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab2GJEEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 00:04:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Boot regression on Mackerel with current mainline
References: <201207031218.24797.rjw@sisk.pl>
	<Pine.LNX.4.64.1207031336320.29890@axis700.grange>
	<201207031910.24864.rjw@sisk.pl>
	<Pine.LNX.4.64.1207041125330.21042@axis700.grange>
Date: Tue, 10 Jul 2012 00:04:27 -0400
In-Reply-To: <Pine.LNX.4.64.1207041125330.21042@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed, 4 Jul 2012 11:39:07 +0200 (CEST)")
Message-ID: <87ipdws1mc.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Wed, Jul 04 2012, Guennadi Liakhovetski wrote:
> On Tue, 3 Jul 2012, Rafael J. Wysocki wrote:
>
>> On Tuesday, July 03, 2012, Guennadi Liakhovetski wrote:
>> > Hi Rafael
>> > 
>> > On Tue, 3 Jul 2012, Rafael J. Wysocki wrote:
>> > 
>> > > Hi,
>> > > 
>> > > We seem to have a functional regression on Mackerel with 3.5-rc5 which
>> > > seems to be related to SDHI.  Namely, the SDHI driver appears to wait forever
>> > > for the devices to appear and commenting out all of the sdhi devices in the
>> > > board file works around the problem.
>> > > 
>> > > I can investigate some more later today if need be.
>> > 
>> > Have you checked the logs? Are you seeing any of these in the kernel log:
>> > 
>> > genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq 
>> 
>> I see this only once per boot, but then sh_mobile_sdhi is saying "timeout
>> waiting for hardware interrupt" pretty much continuously.
>
> Yes, that's the one. Ok, let's fix it in the driver. In fact, a fix has 
> already been submitted, but for 3.6. I hoped, 3.5 would resort to a softer 
> form of the ONESHOT failing, so, I didn't push it for -rc. I think, the 
> easiest would be to apply these two patches:
>
> "mmc: tmio: use MMC opcode defines instead of numbers"
> http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=598cd9cc217b0aa46089a3838a8b1c37b97aa08b
>
> and
>
> "mmc: extend and rename cd-gpio helpers to handle more slot GPIO functions"
> http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=d8e60fb51effc83e6f53de191a8440f46e5a3f2c
>
> The latter one looks big because of a rename, but with "-M" it's pretty 
> trivial. Chris, do you agree?

Is the minimal fix to just add "| IRQF_ONESHOT" to the request_threaded_irq
argument?  If so, I'd rather push just that for 3.5, and I can take care of
having that change appear simultaneously in linux-next so that there aren't
any conflicts.  Is that okay with you?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
