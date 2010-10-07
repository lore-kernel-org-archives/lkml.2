Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab0JGWNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:13:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47008 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0JGWNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:13:40 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Menon\, Nishanth" <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, l-o <linux-omap@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        Paul <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] power: introduce library for device-specific OPPs
Organization: Deep Root Systems, LLC
References: <1286357180-21565-1-git-send-email-nm@ti.com>
	<201010072354.57011.rjw@sisk.pl>
	<7A436F7769CA33409C6B44B358BFFF0C014F748B07@dlee02.ent.ti.com>
Date: Thu, 07 Oct 2010 15:13:37 -0700
In-Reply-To: <7A436F7769CA33409C6B44B358BFFF0C014F748B07@dlee02.ent.ti.com>
	(Nishanth Menon's message of "Thu, 7 Oct 2010 17:03:20 -0500")
Message-ID: <87fwwh7isu.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Menon, Nishanth" <nm@ti.com> writes:

>> -----Original Message-----
>> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>> Sent: Thursday, October 07, 2010 4:55 PM
>
>
>> 
>> Hi,
>> 
>> On Wednesday, October 06, 2010, Nishanth Menon wrote:
>> > SoCs have a standard set of tuples consisting of frequency and
>> > voltage pairs that the device will support per voltage domain. These
>> > are called Operating Performance Points or OPPs. The actual
>> > definitions of OPP varies over silicon versions. For a specific domain,
>> > we can have a set of {frequency, voltage} pairs. As the kernel boots
>> > and more information is available, a default set of these are activated
>> > based on the precise nature of device. Further on operation, based on
>> > conditions prevailing in the system (such as temperature), some OPP
>> > availability may be temporarily controlled by the SoC frameworks.
>> >
>> > To implement an OPP, some sort of power management support is necessary
>> > hence this library depends on CONFIG_PM.
>> 
>> The patch generally looks good to me, I only have a couple of cosmetic
> Thanks for the great reviews.. It did bump up the resultant patch.
>
>> remarks
>> (below).
>> 
>> ...
>> > +static int opp_set_availability(struct device *dev, unsigned long freq,
>> > +		bool availability_req)
>> > +{
>> > +	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
>> > +	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
>> > +	int r = 0;
>> > +
>> > +	/* keep the node allocated */
>> > +	new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
>> > +	if (!new_opp) {
>> > +		pr_warning("Unable to allocate opp\n");
>> 
>> Please add an identification string to the messages, something like
>> "OPP: Unable to allocat object\n" (and similarly in the other messages).
>> That would help to find the source of a message in case there's any
>> problem.
>
> pr_fmt has been reformatted for this. The actual message which will appear
> is as follows:
> opp_set_availability: Unable to allocate opp
>
> is'nt that good enough considering that all functions are opp_ prefixed? 
> I can modify pr_fmt to add "OPP:" but I kinda think it is redundant. But I
> have no strong opinions on that and look forward to your recommendations.

Even more informative would be to use dev_warn() and include the func.
That way we'll even know which device has the problem.

Kevin
