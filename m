Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670Ab2KBCZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:25:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762589Ab2KBCZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:25:22 -0400
Date: Fri, 2 Nov 2012 00:25:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Message-ID: <20121102002508.6c0dcfc2@redhat.com>
In-Reply-To: <20121101235457.GA20890@liondog.tnic>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
	<20121101110512.GA31271@liondog.tnic>
	<20121101094721.2a57719c@redhat.com>
	<20121101195509.GE31271@liondog.tnic>
	<3908561D78D1C84285E8C5FCA982C28F19D5C13C@ORSMSX108.amr.corp.intel.com>
	<20121101220249.GI31271@liondog.tnic>
	<3908561D78D1C84285E8C5FCA982C28F19D5C22B@ORSMSX108.amr.corp.intel.com>
	<20121101235457.GA20890@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 2 Nov 2012 00:54:57 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Thu, Nov 01, 2012 at 11:47:52PM +0000, Luck, Tony wrote:
> > > Right, but at least in the csrow case, we still can compute back the
> > > csrow even with the interleaving, after we know how it is done exactly
> > > (on which address bits, etc). I think this should be doable on Intel
> > > controllers too but I don't know.
> > 
> > No. Architecturally all Intel provides is the physical address in MCi_ADDR.
> > To do anything with that you are into per-system space, and the
> > registers that define the mappings are not necessarily available
> > to OS code ... sometimes they are, and sometimes they are even
> > documented in places where Mauro can use them to write an
> > EDAC driver ... but there are no guarantees.
> 
> One more reason that we need some sort of tables telling us which
> rank/csrow maps to which DIMM and thus silkscreen label so that we can
> be able to say the following from software:

If you take a look at sb_edac driver, you'll see that most of the driver's
logic is the part that do address->DIMM location mapping. It is a very
complex logic.

> 
> "You just had a single corrected ECC error in the DIMM with label
> P0_DIMM_A"

Converting from a DIMM location into a DIMM label is trivial, through:
just a simple table lookup.

As APEI/GHES seem to provide the DIMM location, a simple table lookup
should also work there, as I said before.
 
> or whatever unique naming each platform vendor comes up with.
> 
> The day hw people give me this, I'm going to throw a big party and
> invite all LKML.
> 

-- 
Regards,
Mauro
