Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2DSRGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:06:13 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:53126 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab2DSRGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:06:12 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Trilok Soni <tsoni@codeaurora.org>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        "Cousson\, Benoit" <b-cousson@ti.com>, gregkh@linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-omap@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific macros in include/linux/power
Organization: Texas Instruments, Inc.
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
	<CAORVsuVt5uj5NAsqsce+7f=xMXC9-nck5cPUCOEC8QP3VkxYyA@mail.gmail.com>
	<4F7D6746.9020504@codeaurora.org> <201204191354.38874.arnd@arndb.de>
Date: Thu, 19 Apr 2012 10:06:07 -0700
In-Reply-To: <201204191354.38874.arnd@arndb.de> (Arnd Bergmann's message of
	"Thu, 19 Apr 2012 13:54:38 +0000")
Message-ID: <87sjfzvegw.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Thursday 05 April 2012, Trilok Soni wrote:
>> >> Couple of suggestions:
>> >>
>> >> drivers/platform/omap/avs?
>> >> drivers/misc/omap/avs?
>> >>
>
> I would definitely prefer something under drivers/power,
> drivers/regulators or a new top-level directory under
> drivers.
>
>> >>> IIRC, David Brownell was referring to the rule of three for such case.
>> >>> Meaning that it worth having a generic fmwk when at least three
>> >>> different drivers are doing the same kind of things.
>> >
>> > Do OMAP v1 and OMAP v2 implementations count as 2 drivers? ;-)
>> > More seriously, the OMAP code for SmartReflex is far from complete in
>> > mainline. There is a plan to provide the following features:
>> > - OMAP v1 IP,
>> > - OMAP v2 IP,
>> > - class 1.5,
>> > - class 3,
>> > - class 3.5,
>> > - and more support for the upcoming chipsets.
>> 
>> I don't understand much of these versions right now, but hopefully after 
>> going through all these docs. My only contention point is to not create 
>> any directory into the drivers/power, unless it is generic fwk and then 
>> build up "client" drivers on top of it. Meanwhile we could move this 
>> driver into above options as I have suggested.
>
> I think creating the directory in the place where we want the files
> to stay in the long run is ok, if the plan is to add more drivers and
> make the base code more generic. We don't have to wait until it's too
> late and we absolutely need a framework ;-)

Completely agree, thanks.

> The part I don't understand is how this relates to the regulator framework.
> Is there any overlap between the functionality provided by the
> smartreflex framework and the regulator framework? If so, would it be
> better to extend the existing framework so it can do smartreflex as well?

IMO, there isn't any overlap with the regulator framework, and AVS
drivers/devices should be separate from the regulator framework.

Think of AVS/SmartReflex as a way for hardware to do automatic
micro-adjustments to the regulator.  The regulator voltage (a.k.a
nominal voltage) will stay same from the perspective of the regulator
and regulator framework, but AVS allows the hardware to do micro voltage
adjustments around the nominal voltage.

We recently extended the regulator framework to have allow get/set
voltage hooks which can query platform-specific voltage frameworks which
do hardware voltage control (which in turn can control AVS
sensors/devices.)

Kevin
