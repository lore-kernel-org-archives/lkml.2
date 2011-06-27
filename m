Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1F0Xzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:55:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56025 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab1F0Xys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:54:48 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC 1/8] drivers: add generic remoteproc framework
Thread-Topic: [RFC 1/8] drivers: add generic remoteproc framework
Thread-Index: AQHML+SIQi02E6+wtECtfcP+kXbIPpTSC5UA//+3jZCAAGK6gP//xDIA
Date: Mon, 27 Jun 2011 23:54:30 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202EF28@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-2-git-send-email-ohad@wizery.com>
 <20110627204958.GB20865@ponder.secretlab.ca>
 <FFF198FBBF957F4393BA834040FEFFA202EE00@DFLE35.ent.ti.com>
 <20110627222401.GE20865@ponder.secretlab.ca>
In-Reply-To: <20110627222401.GE20865@ponder.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Grant Likely
> Sent: Monday, June 27, 2011 3:24 PM

> > Our AMPs (remote processors) have a variety of boot mechanisms that vary
> > across the different SoCs (yes, TI likes HW diversity). In some cases, the
> > boot address is more like an entry point and that comes from the firmware,
> > so it is not a static attribute of a driver. Correct me if I misunderstood
> > your question.
> 
> More to the point, I would expect the boot_address to be a property of
> the rproc instance because it represents the configuration of the
> remote processor.  It seems odd that the caller of ->start would know
> better than the rproc driver about the entry point of the processor.
> 
> g.

Yes, in many cases the boot_address will be defined by the HW. However, we have
processors that are "soft" - the boot_address comes from the particular firmware
being loaded and can (will) be different with each firmware image. We factored
out the firmware loader to be device-independent (in remoteproc.c) so it's not
repeated in each device-specific implementation like omap_remoteproc.c and
davinci_remoteproc.c. In the cases where the HW dictates what happens, the start()
method should just ignore the boot_address.

Mark

