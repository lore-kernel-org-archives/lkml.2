Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1E0GTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:19:08 -0400
Received: from ozlabs.org ([203.10.76.45]:55210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1E0GTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:19:07 -0400
Date: Fri, 27 May 2011 13:24:02 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/6] of: Allow scripts/dtc/libfdt to be used from
 kernel code
Message-ID: <20110527032402.GD7793@yookeroo.fritz.box>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
	ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
	grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
 <1305930343-31259-2-git-send-email-ddaney@caviumnetworks.com>
 <20110521063345.GB14828@yookeroo.fritz.box>
 <4DDA8FBC.1090904@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDA8FBC.1090904@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 09:47:56AM -0700, David Daney wrote:
> On 05/20/2011 11:33 PM, David Gibson wrote:
> >On Fri, May 20, 2011 at 03:25:38PM -0700, David Daney wrote:
> >>To use it you need to do this in your Kconfig:
> >>
> >>	select LIBFDT
> >>
> >>And in the Makefile of the code using libfdt something like:
> >>
> >>ccflags-y := -include linux/libfdt_env.h -I$(src)/../../../scripts/dtc/libfdt
> >>
> >>Signed-off-by: David Daney<ddaney@caviumnetworks.com>
> >>---
> >>  drivers/of/Kconfig          |    3 +++
> >>  drivers/of/Makefile         |    2 ++
> >>  drivers/of/libfdt/Makefile  |    3 +++
> >>  drivers/of/libfdt/fdt.c     |    2 ++
> >>  drivers/of/libfdt/fdt_ro.c  |    2 ++
> >>  drivers/of/libfdt/fdt_wip.c |    2 ++
> >
> >No fdt_sw.c or fdt_rw.c?
> >
> 
> I had no immediate need for them.  They could of course be added,
> but that would potentially waste space.
> 
> Let's see if I can make it into an archive library.

That would be preferable.  It's more or less designed to work that way
so that everything is available without using unnecessary space in the
binary.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
