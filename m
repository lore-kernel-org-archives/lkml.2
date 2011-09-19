Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1ISUtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:49:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54457 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1ISUtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:49:52 -0400
Date: Mon, 19 Sep 2011 14:49:48 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Message-ID: <20110919204948.GB30517@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-6-git-send-email-robherring2@gmail.com>
 <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
 <4E71CE5D.9030900@ti.com>
 <4E71F978.6020402@gmail.com>
 <4E72030F.1090300@ti.com>
 <4E722B2D.4050307@gmail.com>
 <4E76615C.3000005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E76615C.3000005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 04:23:40PM -0500, Rob Herring wrote:
> On 09/15/2011 11:43 AM, Rob Herring wrote:
> > I see 2 options (besides leaving it as is):
> > 
> > - Revert back to my previous binding where PPIs are a sub-node and a
> > different interrupt parent.
> > 
> > - Use the current binding, but allow SPIs to start at 0. We can still
> > distinguish PPIs and SPIs by the cpu mask cell. A cpu mask of 0 is a
> > SPI. If there was ever a reason to have a cpu mask for an SPI, you would
> > not be able to with this scheme.
> > 
> > Either way you will still have the above issue with the cell size changing.
> > 
> 
> I was headed down the path of implementing the 2nd option above, but had
> a dilemma. What would be the numbering base for PPIs in this case?
> Should it be 0 in the DT as proposed for SPIs or does it stay at 16?
> Numbering PPIs at 0 will just cause confusion as will numbering
> differently from SPIs. There is absolutely no mention of SPI0 or SPIx
> numbering in the GIC spec. All interrupt number references refer to the
> absolute interrupt ID, not a relative number based on the type.

Hi Rob,

See here[1] and [2] (figures 3.14 and 3.16).  In both cases, there is
clearly a reference to PPI numbering from 0-15 and SPI numbering from
0-987 (as inputs to the distributor block).

[1] http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0416b/Bhacbfdb.html
[2] http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0416b/Cihebcbg.html

g.
