Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2GZAik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:38:40 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:52698 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863Ab2GZAii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:38:38 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [RFC][PATCH 0/14] PM / shmobile: Pass power domain information via DT (was: Re: [RFD] PM: Device tree representation of power domains)
Organization: Texas Instruments, Inc.
References: <201207032302.17805.rjw@sisk.pl> <201207242237.28051.rjw@sisk.pl>
	<201207251300.34892.arnd@arndb.de> <201207260032.40159.rjw@sisk.pl>
Date: Wed, 25 Jul 2012 17:38:35 -0700
In-Reply-To: <201207260032.40159.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 26 Jul 2012 00:32:39 +0200")
Message-ID: <87vchb4ar8.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday, July 25, 2012, Arnd Bergmann wrote:
>> On Tuesday 24 July 2012, Rafael J. Wysocki wrote:
>> > On Tuesday, July 24, 2012, Arnd Bergmann wrote:
>> > > On Tuesday 24 July 2012, Rafael J. Wysocki wrote:
>> > > > On Tuesday, July 24, 2012, Arnd Bergmann wrote:
>> > > > > On Saturday 21 July 2012, Rafael J. Wysocki wrote:
>> > > 
>> > > > > 
>> > > > > Sorry for taking so long to reply. I am really not that familiar with the
>> > > > > power domain requirements, but I do have two comments on your approach:
>> > > > > 
>> > > > > * I think when we want to add a generic concept to the device tree such
>> > > > >   as power domains, we should always make it specified in a generic way.
>> > > > 
>> > > > Do we really want that?  I'm a bit skeptical, because apparently nobody
>> > > > cares, as the (zero) response to this patchset evidently indicates and
>> > > > since nobody cares, it's probably better not to add such "generic" things
>> > > > just yet.

Sorry to jump in late, but it's been another busy dev cycle and I
haven't had the time to look at this series in detail.  But just so you
know that somebody cares, we're also interested in bindings that will be
useful on other SoCs for PM domains.

However, since OMAP powerdomain support pre-dates generic powerdomains ,
the "generic" power domains aren't quite generic enough get for OMAP,
and I haven't had the time to extend the generic code, we haven't yet
moved to generic powerdomains.

>> > > 
>> > > Well, the trouble with bindings is that they are much harder to change
>> > > later, at least in incompatible ways. 
>> > 
>> > Hmm, so I think you wanted to say that it might be burdensome to retain the
>> > code handling the old binding once we had started to use a new generic one.
>> > 
>> > I can agree with that, but that's quite similar to user space interfaces.
>> > Once we've exposed a user space interface of some kind and someone starts
>> > to use it, we'll have to maintain it going forward for the user in question.
>> > However, there is a way to deprecate old user space interfaces and it has
>> > happened.
>> > 
>> > In this particular case the burden would be on Renesas, but I don't think it
>> > would affect anybody else.
>> 
>> [adding devicetree-discuss@lists.ozlabs.org]
>> 
>> In case of user space interfaces, we also try very hard to avoid cases
>> where we know that we will have to change things later.
>
> [Cough, cough]  Yeah, sure.  Except that that's rather difficult to anticipate
> usually.
>
>> I don't think it's that hard to define a generic binding here, we just
>> need to make sure it's extensible.
>> 
>> One thing I would like to avoid is having to add to every single
>> device binding two separate optional properties defined like
>> 
>> diff --git a/Documentation/devicetree/bindings/mmc/mmci.txt b/Documentation/devicetree/bindings/mmc/mmci.txt
>> index 2b584ca..353152e 100644
>> --- a/Documentation/devicetree/bindings/mmc/mmci.txt
>> +++ b/Documentation/devicetree/bindings/mmc/mmci.txt
>> @@ -13,3 +13,9 @@ Required properties:
>>  Optional properties:
>>  - mmc-cap-mmc-highspeed  : indicates whether MMC is high speed capable
>>  - mmc-cap-sd-highspeed   : indicates whether SD is high speed capable
>> +- pm-domain		 : a phandle pointing to the power domain
>> +			   controlling this device
>> +			   See ../pm-domain/generic.txt
>> +- renesas,pm-domain	 : a string with the name of the power domain
>> +			   controlling this device.
>> +			   See ../pm-domain/renesas.txt
>> 
>> Even if you say that the burden is only on Renesas to maintain all those
>> changes to every binding they use, there is also a burden on people trying
>> to understand the binding and deciding which one to use.
>
> What about (tongue in cheek) "renesas,hwmod", then?  That won't be confused
> with the generic "pm-domain" in any way, will it?  And since TI did that, we
> surely should be allowed to do it as well, no?
>
> Seriously, I'm not fundamentally opposed to using phandles for that in analogy
> with regulators, but I'm afraid we won't get it right from the start and it
> will turn out that we need to change the definition of the binding somehow
> and _that_ is going to be painful.  Pretty much like changing generic user
> space interfaces is (as opposed to changing interfaces of limited scope).
>
> However, if that route is taken, I'll expect you to require TI to change their
> hwmod binding in the analogous way.

FWIW, we're already working on making ti,hwmods disappear.  That was a
temporary step to allow us to easily migrate to DT using our existing,
in-tree description of device IP blocks (hwmods.)

That being said, I'm not sure why ti,hwmods is being used as an example
for powerdomains.  hwmods describe the integration of SoC IP blocks
(base addr, IRQ, DMA channel etc., which are being moved to DT) as well
as a bunch of SoC specific PM register descriptions.  This stuff is
SoC-specific PM register layout, so being very SoC specific, it has the
'ti' prefix in the DT binding.

Anyways, I hope to have a closer look this week, and I know Benoit
Cousson (CC'd) has some ideas for DT bindings for power domains as well.
Unfortunately, he's out until next week.

Kevin
