Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1GFGna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:43:30 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:60224 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751731Ab1GFGn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:43:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+pRRWlrs9hrF7/fr3rrpGk
Date: Tue, 5 Jul 2011 23:43:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
        Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] OMAP: hwmod: add kernel cmdline flag to avoid
 resetting IP blocks during init
Message-ID: <20110706064326.GI5783@atomide.com>
References: <20110703010204.19046.85186.stgit@dusk>
 <20110703010206.19046.85293.stgit@dusk>
 <20110704085503.GQ23145@atomide.com>
 <alpine.DEB.2.00.1107051936250.4217@utopia.booyaka.com>
 <alpine.DEB.2.00.1107051955450.4217@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107051955450.4217@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [110705 18:55]:
> On Tue, 5 Jul 2011, Paul Walmsley wrote:
> 
> > For this case, we probably need some board file function to tell the 
> > hwmod code to disregard a device completely, to tell the kernel to 
> > pretend that the device does not exist.
> 
> ... and the other problem here is that we currently probe devices via an 
> arch_initcall(), and the board file init_machine is also an arch_initcall.
> Either we'll need to be very careful about Makefile ordering, or we should 
> just call omap2_init_devices() from the board file init_machine directly.
> The latter makes the most sense to me.

And that can then be passed the list of devices with the special flags
for noreset, disabled and reserved. Then the late_initcall can optionally
reset the rest of the devices.

Regards,

Tony
