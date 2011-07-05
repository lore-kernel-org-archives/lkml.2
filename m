Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1GEQzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:55:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37647 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab1GEQzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:55:03 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC 5/8] remoteproc: add davinci implementation
Thread-Topic: [RFC 5/8] remoteproc: add davinci implementation
Thread-Index: AQHML+P0Hfr3a08OpEW7Q/TK8TF6jpTLaEUAgAB6tVCAARO0AIAACGCAgASPneCAC7rrwIAAvY5w
Date: Tue, 5 Jul 2011 16:54:21 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA2032F6F@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-6-git-send-email-ohad@wizery.com>
	<4E035B78.3080200@mvista.com>
	<FFF198FBBF957F4393BA834040FEFFA202D66E@DFLE35.ent.ti.com>
 <4E04A9AE.3030801@mvista.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024D6C2F29@dbde02.ent.ti.com>
 <FFF198FBBF957F4393BA834040FEFFA202EC99@DFLE35.ent.ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024D91A2CC@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024D91A2CC@dbde02.ent.ti.com>
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

> From: Nori, Sekhar
> Sent: Monday, July 04, 2011 10:35 PM
> To: Grosen, Mark; Sergei Shtylyov

...
> > > Since procedure to set the boot address varies across DaVinci
> > > platforms, you could have a callback populated in platform data
> > > which will be implemented differently for original DaVinci and
> > > DA8xx devices.
> >
> > I looked at DM6467 and it's the same as OMAPL13x, except at a
> different
> > address. Rather than a callback, it could be just an address in the
> > platform data.
> 
> Sounds okay as long as _all_ the DaVinci devices have the same
> bit to be set. Plus, I hope there are no other users of the
> register so that there is no race with other platform code using
> the same register.

Sekhar,

The register is a dedicated 32-bit register that holds the start/boot
address for the DSP, so no other platform code should be using it. Once
the LRST is de-asserted (via the PSC code enhancement), the DSP starts
execution at the address in this register.

Thanks,

Mark
