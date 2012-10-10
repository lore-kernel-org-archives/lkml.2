Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab2JJOT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:19:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59820 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab2JJOTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:19:55 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Mohammed, Afzal" <afzal@ti.com>, Tony Lindgren <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] ARM: OMAP2+: gpmc: Fix kernel BUG for DT boot mode
Thread-Topic: [PATCH] ARM: OMAP2+: gpmc: Fix kernel BUG for DT boot mode
Thread-Index: AQHNpfwrt48rLkiYfEq6qd93BBndrJeyNweAgABhQtA=
Date: Wed, 10 Oct 2012 14:19:40 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EB3B573@DBDE01.ent.ti.com>
References: <1349773040-8204-1-git-send-email-hvaibhav@ti.com>
 <20121010140027.GB13724@beef>
In-Reply-To: <20121010140027.GB13724@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 19:30:27, Porter, Matt wrote:
> On Tue, Oct 09, 2012 at 02:27:20PM +0530, Vaibhav Hiremath wrote:
> > With recent changes in omap gpmc driver code, in case of DT
> > boot mode, where bootloader does not configure gpmc cs space
> > will result into kernel BUG() inside gpmc_mem_init() function,
> > as gpmc cs0 gpmc_config7[0].csvalid bit is set to '1' and
> > gpmc_config7[0].baseaddress is set to '0' on reset.
> > 
> > This use-case is applicable for any board/EVM which doesn't have
> > any peripheral connected to gpmc cs0, for example BeagleXM and
> > BeagleBone, so DT boot mode fails.
> > 
> > This patch adds of_have_populated_dt() check before creating
> > device, so that for DT boot mode, gpmc probe will not be called
> > which is expected behavior, as gpmc is not supported yet from DT.
> > 
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > Cc: Afzal Mohammed <afzal@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc Paul Walmsley <paul@pwsan.com>
> > ---
> > This should go in for rc1, as this breaks AM33xx boot.
> 
> Fixes BeagleBone on mainline.
> 
> Tested-by: Matt Porter <mporter@ti.com>
> 

Thanks Matt and Afzal,

Tony can this be picked up for rc1?? I know you have already sent pull 
request for rc1, but by any chance you are planning to send another request?

Thanks,
Vaibhav
> -Matt
> 

