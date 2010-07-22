Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0GVQNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:13:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:56098 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0GVQNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:13:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,243,1278313200"; 
   d="scan'208";a="588693520"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Date: Thu, 22 Jul 2010 21:43:28 +0530
Subject: RE: [PATCH 1/3] DMAENGINE: generic slave channel control v2
Thread-Topic: [PATCH 1/3] DMAENGINE: generic slave channel control v2
Thread-Index: Acspilg1i5AEec1fRGKm87RyPSAOswALSfqg
Message-ID: <438BB0150E931F4B9CE701519A44630104A3914683@bgsmsx502.gar.corp.intel.com>
References: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTimmJJcMXxICZHjksp_TjqO_JRx9HwCTJ6UpZQOZ@mail.gmail.com>
In-Reply-To: <AANLkTimmJJcMXxICZHjksp_TjqO_JRx9HwCTJ6UpZQOZ@mail.gmail.com>
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

> 2010/7/22 Linus Walleij <linus.walleij@stericsson.com>:
> 
> > This adds an interface to the DMAengine to make it possible to
> > reconfigure a slave channel at runtime. We add a few foreseen
> > config parameters to the passed struct, with a void * pointer
> > for custom per-device or per-platform runtime slave data.
> 
> BTW Vinod, if you're happy with this API, then please ACK it so
> Dan has some indication whether it'll fit the Moorestown too.

Shouldn't this patch remove the private member in dma_chan structure

Currently chan->private is used for sending slave or similar channel specific 
information. Now if we want to add struct dma_slave_config, then IMHO it 
would make sense to remove private variable and replace with dma_slave_config 
struture. That way we can reuse this struture there as well and if someone wants
to add more stuff he can use the private_config.

Dan, what do you think about this?

Thanks
-Vinod
