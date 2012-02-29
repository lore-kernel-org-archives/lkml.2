Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757Ab2B2HCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:02:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49403 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab2B2HCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:02:39 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Thread-Topic: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Thread-Index: AQHM8jX94hGGsvaFkE+bBaOmSVmhh5ZQdwIAgAFTzjCAAW7tQA==
Date: Wed, 29 Feb 2012 07:01:52 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3176D90F@DBDE01.ent.ti.com>
References: <y> <1330005504-25321-3-git-send-email-prakash.pm@ti.com>
	<20120227142638.GN27687@sortiz-mobl>
 <A73F36158E33644199EB82C5EC81C7BC3176D103@DBDE01.ent.ti.com>
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3176D103@DBDE01.ent.ti.com>
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

On Tue, Feb 28, 2012 at 11:14:39, Manjunathappa, Prakash wrote:
> Hi Samuel,
> 
> On Mon, Feb 27, 2012 at 19:56:38, Samuel Ortiz wrote:
> [snip]
> > So it seems you're passing a platform devices array through your mfd aemif
> > platform data pointer. And from what I can see, it's mostly a 1 entry array
> > (for the NAND case) or a 2 entries array (for the NAND and NOR case).
> > In that case, adding an MFD driver in the middle brings basically nothing but
> > confusion and overhead (and 200+ lines of code).
> > So unless someone explains to me how this is doing any good to the kernel in
> > general, I'm not going to take this patchset.
> > 
> > Cheers,
> > Samuel.
> >
> 
> In this way we trying to isolate future modification of aemif driver not to depict
> as platform code change, the need for this is based on discussion in below thread
> http://davinci-linux-open-source.1494791.n2.nabble.com/PATCH-arm-davinci-configure-davinci-aemif-chipselects-through-OF-tt7059739.html#none
> 
> Earlier also concern was expressed to move aemif driver out of arch/arm to drivers folder.
> Here is the link for the same: http://lists.infradead.org/pipermail/linux-mtd/2011-August/037308.html
> Since aemif driver supports NAND/NOR devices, we feel MFD is the place holder.
> 
> Thanks,
> Prakash

Some more information which I missed out earlier:
DaVinci AEMIF is an async memory interface, driver for which was implemented in
arch/arm/mach-davinci/aemif.c. It can be interfaced to NAND, NOR and other
asynchronous memories. Currently it just provides an API for timing value
configuration. The API is invoked by the MTD NAND driver. 

Specification here: http://www.ti.com/lit/ug/sprue20c/sprue20c.pdf

Reason for moving it to MFD frame work:
1) AEMIF is also present on devices belonging to arch-c6x and arch-omap2 architectures.
   So having the driver in architecture neutral place seems to be the way to go.
2) Other than NAND/NOR there are use cases where people are interfacing other devices,
   for eg: FPGAs through UIO framework. So MTD is not the place for AEMIF driver.

Taking above points into consideration Arnd Bergmann suggested to move AEMIF driver to
MFD framework. Here is the link:
http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-December/010295.html

Thanks,
Prakash
