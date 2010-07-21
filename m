Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096Ab0GUDJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 23:09:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:28024 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762072Ab0GUDJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 23:09:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,235,1278313200"; 
   d="scan'208";a="820043388"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Date: Wed, 21 Jul 2010 08:38:09 +0530
Subject: RE: [PATCH 1/3] DMAENGINE: generic slave channel control
Thread-Topic: [PATCH 1/3] DMAENGINE: generic slave channel control
Thread-Index: AcsoUkDkG3wNieAhT8+dpgt4UDGJcQALktDA
Message-ID: <438BB0150E931F4B9CE701519A44630104A3641362@bgsmsx502.gar.corp.intel.com>
References: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
	<AANLkTinqKHCYeGTLuTtKikcR2IA8TY0vy2tSznxLay0N@mail.gmail.com>
	<AANLkTimHBWMYAeFrET2EpeA8KogcUmQldAHM_uhSv-gt@mail.gmail.com>
	<AANLkTil_2nzwEUS56U48CJpdqkrpnGXAwfcE9bU_Wqhw@mail.gmail.com>
	<AANLkTilAGPmOuS_LjA3TEq1mIcqLxX-T7P-PI-lBTZi0@mail.gmail.com>
	<438BB0150E931F4B9CE701519A44630104A3640CF7@bgsmsx502.gar.corp.intel.com>
 <AANLkTilZ14AEPqhwfvPbmvuBOIeSZPlHa1u4DR2GuoEC@mail.gmail.com>
In-Reply-To: <AANLkTilZ14AEPqhwfvPbmvuBOIeSZPlHa1u4DR2GuoEC@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ? Are you using memcpy() to talk to slaves?
Yes, I don't have sg support yet, that's something I need to add next.

> I was assuming all slave communication was to use sglists through
> the .device_prep_slave_sg() call. This is currently the design constraint,
> memcpy() will by design increase both source and destination address
> and also always operate on the memory bus.
> 
> (If you need reconfiguration also for memcpy() I think will be a
> different issue, I'm only looking at slaves now.)
> 
> With only the slave interface the dma_chan struct can be deferred
> by the DMA engine into a local struct which has this address configured
> from the platform, statically.
> 
> The runtime configuration API is exactly about being able to reconfigure
> even the source/destination address at runtime. This is why
> these are on the interface.
Okay looking at the sg API, now I can understand why you need the address in
this structure, I would also need that in future.
One suggestion since we are giving io address here, how about naming the 
variable as io_addr, and we can add comment to be used for sg operations as io 
addr if anyone wants to use memcpy() they can ignore this


Thanks
Vinod
