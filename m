Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1FXEcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 00:32:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47371 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1FXEcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 00:32:22 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Michael Williamson <michael.williamson@criticallink.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>
Subject: RE: [RFC 0/8] Introducing a generic AMP/IPC framework
Thread-Topic: [RFC 0/8] Introducing a generic AMP/IPC framework
Thread-Index: AQHML+QkyBZcsabgrUapQCsRzbK3+pTLNMCA///qS/CAAIC/gIAATdwQ
Date: Fri, 24 Jun 2011 04:32:08 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202D682@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <4E033041.9090606@criticallink.com>
 <FFF198FBBF957F4393BA834040FEFFA202CA6E@DFLE35.ent.ti.com>
 <201106232046.35846.arnd@arndb.de>
In-Reply-To: <201106232046.35846.arnd@arndb.de>
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

> From: Arnd Bergmann
> Sent: Thursday, June 23, 2011 11:47 AM
> Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
> 
> On Thursday 23 June 2011 18:27:10 Grosen, Mark wrote:
> > First, we are not abandoning DSPLINK. We have many users of this, even
> > though it is out-of-tree, and we will continue to support it. That said, we
> > do intend to make this new design the basis for DSPLINK-like
> > functionality. It's designed to be done "the right way" for Linux (and we
> > are looking for feedback to make it better).  It is also designed to be more
> > scalable and extensible in userspace. With a solid kernel foundation, we can
> > provide lots of functionality in userspace, or users can implement their own
> > custom solutions. One of the key things to do is map our existing DSPLINK
> > APIs, like MessageQ, to the new rpmsg transport.
> 
> Sounds all good. What about the PRUSS code? Does that fit into the new
> model as well?
> 
> 	Arnd

Arnd,

Yes, I have been following some of the PRUSS discussion. I think the
remoteproc driver could be used to manage the basic load/start/stop of the
PRUSS processor. I am not sure if the virio/rpmsg part would be a good
fit. The PRUSS processor is pretty limited, so the generality of virtio
might be too much to fit and too much overhead. However, one of the good
things about remoteproc currently is that it is standalone, so other
transports could use it via the rproc_get/put methods.

Mark
