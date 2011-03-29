Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1C2PQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:16:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51799 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1C2PQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:16:51 -0400
Date: Tue, 29 Mar 2011 17:16:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/30] amd64_edac: Cleanup chipselect handling
Message-ID: <20110329151643.GA22419@aftab>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
 <1297358133-14320-6-git-send-email-bp@amd64.org>
 <4D91F31A.7040600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D91F31A.7040600@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 10:56:26AM -0400, Mauro Carvalho Chehab wrote:
> Em 10-02-2011 15:15, Borislav Petkov escreveu:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add a struct representing the DRAM chip select base/limit register
> > pairs. Concentrate all CS handling in a single function. Also, add CS
> > looping macros for cleaner, more readable code. While at it, adjust code
> > to F15h. Finally, do smaller macro names cleanups (remove family names
> > from register macros) and debug messages clarification.
> > 
> > No functional change.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi Borislav,
> 
> > --- a/drivers/edac/amd64_edac.h
> > +++ b/drivers/edac/amd64_edac.h
> > @@ -160,6 +160,14 @@
> >  #define OFF false
> >  
> >  /*
> > + * Create a contiguous bitmask starting at bit position @lo and ending at
> > + * position @hi. For example
> > + *
> > + * GENMASK(21, 39) gives us the 64bit vector 0x000000ffffe00000.
> > + */
> > +#define GENMASK(lo, hi)			(((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))
> > +
> 
> This is a nice macro that could be useful outside amd64. It is probably a good
> idea to move it to include/linux/bitops.h.

I'd suggest rather <drivers/edac/edac_core.h> if you want to use it in
EDAC. But if we have more users, I don't have a problem with putting
it there (or somewhere else generic enough if people have a better
suggestion).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
