Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409Ab2JaRwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:52:24 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:48615 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759233Ab2JaRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:52:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/grV67YZTUEN6xZmm4xV+0
Date: Wed, 31 Oct 2012 10:52:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121031175219.GH12739@atomide.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [121031 10:26]:
> It is painless to move the adapter DT devices to arch/arm/mach-omap2
> 
> However I got bit by the __init at omap_build_device family functions.
> If you don't remove it, crashes every time you instantiate a device
> at runtime, or you load the cape driver as a module.

Hmm I think you misunderstood me. You only need to create the
platform_device under arch/arm/mach-omap2. The device creation
happens only at __init, so omap_build_device can stay as __init.
The driver itself should be under drivers.

But is this bus on non-device-tree omaps? If not, just make it
device tree only.

Regards,

Tony
