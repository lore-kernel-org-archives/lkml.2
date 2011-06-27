Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1F0Vww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:52:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42786 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1F0Vwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:52:46 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>, Ohad Ben-Cohen <ohad@wizery.com>
CC: davinci-linux-open-source 
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
Thread-Index: AQHML+SIQi02E6+wtECtfcP+kXbIPpTSC5UA//+3jZA=
Date: Mon, 27 Jun 2011 21:52:30 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202EE00@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-2-git-send-email-ohad@wizery.com>
 <20110627204958.GB20865@ponder.secretlab.ca>
In-Reply-To: <20110627204958.GB20865@ponder.secretlab.ca>
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
> Sent: Monday, June 27, 2011 1:50 PM

Grant, thanks for the feedback. I'll try to answer one of your
questions below and leave the rest for Ohad.

Mark
 
> > +Every remoteproc implementation must provide these handlers:
> > +
> > +struct rproc_ops {
> > +	int (*start)(struct rproc *rproc, u64 bootaddr);
> > +	int (*stop)(struct rproc *rproc);
> > +};
> > +
> > +The ->start() handler takes a rproc handle and an optional bootaddr
> argument,
> > +and should power on the device and boot it (using the bootaddr
> argument
> > +if the hardware requires one).
> 
> Naive question: Why is bootaddr an argument?  Wouldn't rproc drivers
> keep track of the boot address in their driver private data?
 
Our AMPs (remote processors) have a variety of boot mechanisms that vary
across the different SoCs (yes, TI likes HW diversity). In some cases, the
boot address is more like an entry point and that comes from the firmware,
so it is not a static attribute of a driver. Correct me if I misunderstood
your question.

Mark
