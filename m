Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2IJF4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:56:19 -0400
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:48285 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751394Ab2IJF4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:56:17 -0400
X-Greylist: delayed 44648 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2012 01:56:17 EDT
Date: Mon, 10 Sep 2012 07:53:39 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120910055339.GC31430@game.jcrosoft.org>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
 <20120909172046.GB31430@game.jcrosoft.org>
 <alpine.LFD.2.02.1209091923180.28681@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1209091923180.28681@xanadu.home>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9295148157662636984
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:29 Sun 09 Sep     , Nicolas Pitre wrote:
> On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> > > +4. Call the kernel image
> > > +------------------------
> > > +
> > > +Requirement: MANDATORY
> > > +
> > > +The decompressed kernel image contains a 32-byte header as follows:
> > > +
> > > +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
> > > +  u32 res0	= 0;		/* reserved */
> > > +  u64 text_offset;		/* Image load offset */
> > > +  u64 res1	= 0;		/* reserved */
> > > +  u64 res2	= 0;		/* reserved */
> > we need to have a magic to known it's a arm64 kernel
> 
> You have it: it's 0x14000008 at the beginning.
fragile
> 
> > > +
> > > +The image must be placed at the specified offset (currently 0x80000)
> > > +from the start of the system RAM and called there. The start of the
> > > +system RAM must be aligned to 2MB.
> > can we drop this
> 
> Drop what?
> And why?
This contrain the must be loadable at any address

Best Regards,
J.
