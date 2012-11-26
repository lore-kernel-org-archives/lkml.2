Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2KZVd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:33:59 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45938 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2KZVd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:33:57 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V3 3/3] mfd: stmpe: Update DT support in stmpe driver
To: Viresh Kumar <viresh.kumar@linaro.org>, lee.jones@linaro.org
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
In-Reply-To: <CAKohpomAM2pw9kgB6khtHzQ2WCXKZ9_pi1_sOH2dQToVS8ep4w@mail.gmail.com>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org> <7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org> <20121123094132.EFCB73E07BE@localhost> <CAKohpomAM2pw9kgB6khtHzQ2WCXKZ9_pi1_sOH2dQToVS8ep4w@mail.gmail.com>
Date: Mon, 26 Nov 2012 18:40:15 +0000
Message-Id: <20121126184015.784993E091F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012 23:03:47 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 23 November 2012 15:11, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Fri, 23 Nov 2012 00:26:20 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> 
> >> + - irq-trigger                       : IRQ trigger to use for the interrupt to the host
> >> + - irq-invert-polarity               : bool, IRQ line is connected with reversed polarity
> >
> > This looks odd. Normally the interrupt polarity should be encoded in the irq
> > specifier flags field.
> 
> Hi Grant and Lee Jones,
> 
> This looks odd because stmpe is odd, i am taking the discussion held
> with Lee jones to this thread.
> 
> So, how interrupt stuff works currently in DT..
> We have a interrupt controller IC:
> 
> 	ic: interrupt-controller@40008000 {
> 		compatible = "foo";
> 		interrupt-controller;
> 		#interrupt-cells = <2>;
>                 ...
> 	};
> 
> And we have a user of this IC:
> 
> 	foo-peripheral@40048000 {
> 		compatible = "foo-peripheral";
> 		interrupt-parent = <&ic>;
> 		interrupts = <39 4>;
> 	};
> 
> Here first field of "interrupts" gives interrupt line number and the second one
> gives polarity, interrupt type etc..
> 
> All is good till now. Now, every interrupt controller supports the first
> field, but the second one depends on its capabilities. An interrupt controller
> might not have registers to configure interrupt polarity, type, etc of
> the interrupt
> it will service and so the second field wouldn't be available for them.
> 
> For now just think stmpe is not a MFD and not a interrupt controller
> either. It is
> just a simple device, dev-foo.
> 
> It will declare values of its interrupts field based on the type of
> interrupt controller
> that will service its interrupt and that can be anything like VIC/GIC/GPIO
> controller.

Ah, so it is configuring the way the device emits interrupts; not how
the interrupt controller processes them. Fair enough.

It would actually be good to ask the interrupt controller driver what
kind of interrupt signal it expects for a given interrupt line. That
should also solve the problem and I think it would be more useful to
other devices. Can you investigate whether or not
irqd_get_trigger_type() returns the information you need?

g.

