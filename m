Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1GFCAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 22:00:49 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:39259 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1GFCAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 22:00:48 -0400
Date: Tue, 5 Jul 2011 20:00:47 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>,
        =?ISO-8859-15?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] OMAP: hwmod: add kernel cmdline flag to avoid resetting
 IP blocks during init
In-Reply-To: <alpine.DEB.2.00.1107051936250.4217@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1107051955450.4217@utopia.booyaka.com>
References: <20110703010204.19046.85186.stgit@dusk> <20110703010206.19046.85293.stgit@dusk> <20110704085503.GQ23145@atomide.com> <alpine.DEB.2.00.1107051936250.4217@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011, Paul Walmsley wrote:

> For this case, we probably need some board file function to tell the 
> hwmod code to disregard a device completely, to tell the kernel to 
> pretend that the device does not exist.

... and the other problem here is that we currently probe devices via an 
arch_initcall(), and the board file init_machine is also an arch_initcall.
Either we'll need to be very careful about Makefile ordering, or we should 
just call omap2_init_devices() from the board file init_machine directly.
The latter makes the most sense to me.


- Paul
