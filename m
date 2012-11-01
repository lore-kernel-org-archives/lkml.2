Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399Ab2KAWCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:02:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39950 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab2KAWCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:02:52 -0400
Date: Thu, 1 Nov 2012 23:02:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Message-ID: <20121101220249.GI31271@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
 <20121101110512.GA31271@liondog.tnic>
 <20121101094721.2a57719c@redhat.com>
 <20121101195509.GE31271@liondog.tnic>
 <3908561D78D1C84285E8C5FCA982C28F19D5C13C@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D5C13C@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 09:09:07PM +0000, Luck, Tony wrote:
> > That is correct, unfortunately. That information is not available to
> > software in all cases. Maybe APEI could be used for that DIMM location
> > mapping through simple tables instead of letting it fumble the error
> > handling path.
> 
> Not much hope for "simple"[1] tables.  There is also a timings issue on
> system with rank sparing, memory mirroring etc.  ... you need to decode
> to the DIMM at the time the error happened. If you wait until later, then
> the system may have switched over to the spare rank or mirror ... and then
> your decode will point at the new target, rather than the old.

Yeah, normally we're decoding the error right after being logged so...

> [1] Consider a 4 cpu-socket machine with 4 channels per socket and three
> DIMMs per channel - so there are 48 sockets on the motherboard. Then

You mean 48 DIMM slots, right?

> some lab monkey takes a box of random 1, 2, 4, 8 GB DIMMs and fills
> most of the sockets. BIOS will somehow make sense out of this and
> interleave where it finds matching speeds across pairs/quads of
> channels (though size need not match ... if you have a 2G and 4G DIMM
> you may get interleaving for the part. then non-interleaved for the
> "extra" 2G).

Right, but at least in the csrow case, we still can compute back the
csrow even with the interleaving, after we know how it is done exactly
(on which address bits, etc). I think this should be doable on Intel
controllers too but I don't know.

-- 
Regards/Gruss,
    Boris.
