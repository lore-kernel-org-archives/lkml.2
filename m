Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649Ab2CFNNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:13:10 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49975 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030441Ab2CFNNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:13:07 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Thread-Topic: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Thread-Index: AQHM8jX94hGGsvaFkE+bBaOmSVmhh5ZQdwIAgAFTzjCAAzAEgIAH0xCQ
Date: Tue, 6 Mar 2012 13:12:25 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC317702E9@DBDE01.ent.ti.com>
References: <y> <1330005504-25321-3-git-send-email-prakash.pm@ti.com>
 <20120227142638.GN27687@sortiz-mobl>
 <A73F36158E33644199EB82C5EC81C7BC3176D103@DBDE01.ent.ti.com>
 <20120301112329.GI9008@sortiz-mobl>
In-Reply-To: <20120301112329.GI9008@sortiz-mobl>
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

Hi Samuel,

May be I did not do a good job giving complete information on this earlier.
So I have replied on top of my mail with below information (seems you missed it)

More information on AEMIF:
DaVinci AEMIF is an async memory interface, driver for which was implemented
in arch/arm/mach-davinci/aemif.c. It can be interfaced to NAND, NOR and other
asynchronous memories. Currently it just provides an API for timing value configuration.
The API is invoked by the MTD NAND driver. 

Specification here: http://www.ti.com/lit/ug/sprue20c/sprue20c.pdf

Reason for moving it to MFD frame work:
1) AEMIF is also present on devices belonging to arch-c6x and arch-omap2 architectures.
   So having the driver in architecture neutral place seems to be the way to go.
2) Other than NAND/NOR there are use cases where people are interfacing other devices,
   for eg: FPGAs through UIO framework. So MTD is not the place for AEMIF driver.

Taking above points into consideration Arnd Bergmann suggested to move AEMIF driver to
MFD framework [1], relevant portion of his mail as follows,

" If you want it to provide endpoint devices that are handled by
distinct subsystems in Linux, I would make it an mfd multifunction
device and make the common... "

[1] http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-December/010295.html

Thanks,
Prakash

On Thu, Mar 01, 2012 at 16:53:29, Samuel Ortiz wrote:
> Hi Prakash,
> 
> On Tue, Feb 28, 2012 at 05:44:39AM +0000, Manjunathappa, Prakash wrote:
> > Hi Samuel,
> > 
> > On Mon, Feb 27, 2012 at 19:56:38, Samuel Ortiz wrote:
> > [snip]
> > > So it seems you're passing a platform devices array through your mfd aemif
> > > platform data pointer. And from what I can see, it's mostly a 1 entry array
> > > (for the NAND case) or a 2 entries array (for the NAND and NOR case).
> > > In that case, adding an MFD driver in the middle brings basically nothing but
> > > confusion and overhead (and 200+ lines of code).
> > > So unless someone explains to me how this is doing any good to the kernel in
> > > general, I'm not going to take this patchset.
> > > 
> > > Cheers,
> > > Samuel.
> > >
> > 
> > In this way we trying to isolate future modification of aemif driver not to depict
> > as platform code change, the need for this is based on discussion in below thread
> > http://davinci-linux-open-source.1494791.n2.nabble.com/PATCH-arm-davinci-configure-davinci-aemif-chipselects-through-OF-tt7059739.html#none
> > 
> I fail to see how you're going to achieve that with adding an MFD platform
> device registration in the middle.
> 
> 
> > Earlier also concern was expressed to move aemif driver out of arch/arm to drivers folder.
> > Here is the link for the same: http://lists.infradead.org/pipermail/linux-mtd/2011-August/037308.html
> > Since aemif driver supports NAND/NOR devices, we feel MFD is the place holder.
> I would disagree with that. And it certainly makes sense to move many drivers
> out of arch/arm into a more appropriate place but I'd like to keep mfd as
> something else than yet another misc.
> 
> Cheers,
> Samuel.
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/
> 

