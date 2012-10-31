Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946069Ab2JaVnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:43:17 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:36159 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946048Ab2JaVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:43:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+WcMfvph1S47Gli2NfMtd5
Date: Wed, 31 Oct 2012 14:43:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121031214310.GA15766@atomide.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
 <20121031175219.GH12739@atomide.com>
 <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
 <20121031180935.GL12739@atomide.com>
 <50918223.6080003@ti.com>
 <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
 <20121031212639.GQ12739@atomide.com>
 <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [121031 14:38]:
> 
> There a a whole bunch of conflicting capes. There's no
> way to instantiate them together. They must be instantiated
> only after their EEPROMs are read and they are matched
> to their corresponding cape drivers.

You don't need to instantiate the capes during __init,
you need to just instantiate the omap internal devices
which are always there in the hardware. These internal
devices just need to be set to state = "disabled" until
they are used.

The capes themselves should not have anything to do
with omap_hwmod or omap_device, they just contain
external connectors, regulators, LCD panels etc.

To your capebus the omap internal devices should look
like just regular struct device entries.

Regards,

Tony
