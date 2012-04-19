Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2DSQCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:02:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55995 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab2DSQCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:02:45 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.84.216]
In-Reply-To: <201204191354.38874.arnd@arndb.de>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
	<CAORVsuVt5uj5NAsqsce+7f=xMXC9-nck5cPUCOEC8QP3VkxYyA@mail.gmail.com>
	<4F7D6746.9020504@codeaurora.org>
	<201204191354.38874.arnd@arndb.de>
Date: Thu, 19 Apr 2012 18:02:44 +0200
Message-ID: <CAORVsuUbW+n=xwRzNuUz17viWiTSbdqTLoPAzLr3Np9ws_K6xA@mail.gmail.com>
Subject: Re: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific
 macros in include/linux/power
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Trilok Soni <tsoni@codeaurora.org>,
        Kevin Hilman <khilman@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        gregkh@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        Jean Pihet <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Apr 19, 2012 at 3:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
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
Can I take this as an OK for drivers/power/avs as suggested?

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
Agree! That is the intention to provide a fwk.

> The part I don't understand is how this relates to the regulator framework.
> Is there any overlap between the functionality provided by the
> smartreflex framework and the regulator framework? If so, would it be
> better to extend the existing framework so it can do smartreflex as well?
The link with regulator has indeed an impact on the target dir, this
is still unknown and discussed internally.

>
>        Arnd

Thanks,
Jean
