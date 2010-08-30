Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0H3BkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:40:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:36318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab0H3BkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:40:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,289,1280732400"; 
   d="scan'208";a="652447136"
Subject: RE: [PATCH 2/2] hwmon: (coretemp) Get TjMax value from MSR
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc: "Wan, Huaxu" <huaxu.wan@intel.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'lm-sensors@lm-sensors.org'" <lm-sensors@lm-sensors.org>,
        "'khali@linux-fr.org'" <khali@linux-fr.org>
In-Reply-To: <1280132188.22558.0.camel@maxim-laptop>
References: <20100507095945.GB12190@owl>
	 <1275111551.3427.4.camel@maxim-laptop>  <20100531013950.GA8265@owl>
	 <1275496456.32562.4.camel@maxim-laptop>
	 <1275509416.6277.2.camel@maxim-laptop>
	 <1276347839.4481.22.camel@maxim-laptop>
	 <625BA99ED14B2D499DC4E29D8138F1502C5405FCB0@shsmsx502.ccr.corp.intel.com>
	 <1280132188.22558.0.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 09:42:36 +0800
Message-ID: <1283132556.2159.9.camel@owl>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Fenghua. 

Could you found a Laptop with T5450 at hand? I can't found anywhere.

-Huaxu

On Mon, 2010-07-26 at 11:16 +0300, Maxim Levitsky wrote:
> On Sun, 2010-06-13 at 10:27 +0800, Wan, Huaxu wrote: 
> > >On Wed, 2010-06-02 at 23:10 +0300, Maxim Levitsky wrote: 
> > >> On Wed, 2010-06-02 at 19:34 +0300, Maxim Levitsky wrote: 
> > >> > On Mon, 2010-05-31 at 09:39 +0800, Huaxu Wan wrote: 
> > >> > > On 08:39 Sat 29 May, Maxim Levitsky wrote:
> > >> > > > On Fri, 2010-05-07 at 17:59 +0800, Huaxu Wan wrote: 
> > >> > > > > The MSR IA32_TEMPERATURE_TARGET contains the TjMax 
> > >value in the newer
> > >> > > > > processers.
> > >> > > > 
> > >> > > > I know that TjMax on my system is 85, and now coretemp 
> > >reports wrong
> > >> > > > temperatures.
> > >> > > > First of all BIOS using stupid tricks actualy reports 
> > >CPU temperature
> > >> > > > through ACPI, and assuming it was correct TjMax is 85.
> > >> > > > It also shuts down the system if I 'lie' to it that 
> > >cpu temperature is
> > >> > > > 85C.
> > >> > > 
> > >> > > From the list at [1], the TjMax(Tjunction) of T5450 is 
> > >100C. Does anyone
> > >> > > here can make a double check?
> > >> > > 
> > >> > > [1] 
> > >http://ark.intel.com/Product.aspx?id=30787&processor=T5450&spec
> > >-codes=SLA4F
> > >> > 
> > >> > This is very interesting.
> > >> > 
> > >> > With TjMax 85C, the CPUs idle temperature is reported at 
> > >around 45~50C
> > >> > GPU temperature that is around 50C 
> > >> > 
> > >> > BIOS also reports 45~50C.
> > >> > 
> > >> > BIOS hooks an SMI to CPU thermal report, and stores the 
> > >temperature it
> > >> > read in ram, then ACPI code reads it, reports and passes to the EC
> > >> > (embedded controller).
> > >> > 
> > >> > If I write myself 85 to embedded controller, systems shuts down.
> > >> > (values less that 85, eg 84 don't shut system).
> > >> 
> > >> 
> > >> Another clue is that right after resume from ram, after long delay
> > >> (~hour) the displayed temperature with TjMax 85 is 33C. Since room
> > >> temperature here is around 27C, this seems more plausible that 
> > >> 33 + 15 = 48C 
> > >
> > >
> > >Any update? 
> > 
> > I'm occupied by other things, sorry for slow response. But, as said in a 
> > spec, I can't remember which one now, there are too many, the relative
> > value read from DTS is accurate approaching to TjMax. The accuracy
> > deteriorates to +-10C at 50C. Any DTS reading below 50C should be
> > considered to indicate only a temperature below 50C and not a specific
> > temperature.
> > 
> > So, the value around 50C can't be taken as real chip temperature. I
> > would like this issue could be confirmed by more users to avoid it as a 
> > particular case. At the meantime, I still looking for a laptop with T5450, 
> > this may take some time. 
> > 
> > Thanks
> > Huaxu 
> 
> Any update?
> 
> Best regards,
> Maxim Levitsky
> 


