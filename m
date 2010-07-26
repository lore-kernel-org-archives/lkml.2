Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0GZIQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:16:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36802 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0GZIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dwNpOFcOsta3ZvKytKptCimghPli+cacgSlvyrq0zMEA5OZW8ZysIPOFsiAuaRZ3kf
         tIliC5+smnNwdHVnelYkBwThPL0bigx6DNgupHqD4P0rdiktidGHyrsDOKIC5yMqfVRW
         4qK+k7TI1YJrhxL4ZGRNmPExZahCXlr2UONgY=
Subject: RE: [PATCH 2/2] hwmon: (coretemp) Get TjMax value from MSR
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Wan, Huaxu" <huaxu.wan@intel.com>
Cc: "'Huaxu Wan'" <huaxu.wan@linux.intel.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'lm-sensors@lm-sensors.org'" <lm-sensors@lm-sensors.org>,
        "'khali@linux-fr.org'" <khali@linux-fr.org>
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1502C5405FCB0@shsmsx502.ccr.corp.intel.com>
References: <20100507095945.GB12190@owl>
	 <1275111551.3427.4.camel@maxim-laptop>  <20100531013950.GA8265@owl>
	 <1275496456.32562.4.camel@maxim-laptop>
	 <1275509416.6277.2.camel@maxim-laptop>
	 <1276347839.4481.22.camel@maxim-laptop>
	 <625BA99ED14B2D499DC4E29D8138F1502C5405FCB0@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 11:16:28 +0300
Message-ID: <1280132188.22558.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 10:27 +0800, Wan, Huaxu wrote: 
> >On Wed, 2010-06-02 at 23:10 +0300, Maxim Levitsky wrote: 
> >> On Wed, 2010-06-02 at 19:34 +0300, Maxim Levitsky wrote: 
> >> > On Mon, 2010-05-31 at 09:39 +0800, Huaxu Wan wrote: 
> >> > > On 08:39 Sat 29 May, Maxim Levitsky wrote:
> >> > > > On Fri, 2010-05-07 at 17:59 +0800, Huaxu Wan wrote: 
> >> > > > > The MSR IA32_TEMPERATURE_TARGET contains the TjMax 
> >value in the newer
> >> > > > > processers.
> >> > > > 
> >> > > > I know that TjMax on my system is 85, and now coretemp 
> >reports wrong
> >> > > > temperatures.
> >> > > > First of all BIOS using stupid tricks actualy reports 
> >CPU temperature
> >> > > > through ACPI, and assuming it was correct TjMax is 85.
> >> > > > It also shuts down the system if I 'lie' to it that 
> >cpu temperature is
> >> > > > 85C.
> >> > > 
> >> > > From the list at [1], the TjMax(Tjunction) of T5450 is 
> >100C. Does anyone
> >> > > here can make a double check?
> >> > > 
> >> > > [1] 
> >http://ark.intel.com/Product.aspx?id=30787&processor=T5450&spec
> >-codes=SLA4F
> >> > 
> >> > This is very interesting.
> >> > 
> >> > With TjMax 85C, the CPUs idle temperature is reported at 
> >around 45~50C
> >> > GPU temperature that is around 50C 
> >> > 
> >> > BIOS also reports 45~50C.
> >> > 
> >> > BIOS hooks an SMI to CPU thermal report, and stores the 
> >temperature it
> >> > read in ram, then ACPI code reads it, reports and passes to the EC
> >> > (embedded controller).
> >> > 
> >> > If I write myself 85 to embedded controller, systems shuts down.
> >> > (values less that 85, eg 84 don't shut system).
> >> 
> >> 
> >> Another clue is that right after resume from ram, after long delay
> >> (~hour) the displayed temperature with TjMax 85 is 33C. Since room
> >> temperature here is around 27C, this seems more plausible that 
> >> 33 + 15 = 48C 
> >
> >
> >Any update? 
> 
> I'm occupied by other things, sorry for slow response. But, as said in a 
> spec, I can't remember which one now, there are too many, the relative
> value read from DTS is accurate approaching to TjMax. The accuracy
> deteriorates to +-10C at 50C. Any DTS reading below 50C should be
> considered to indicate only a temperature below 50C and not a specific
> temperature.
> 
> So, the value around 50C can't be taken as real chip temperature. I
> would like this issue could be confirmed by more users to avoid it as a 
> particular case. At the meantime, I still looking for a laptop with T5450, 
> this may take some time. 
> 
> Thanks
> Huaxu 

Any update?

Best regards,
Maxim Levitsky

