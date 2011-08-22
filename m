Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1HVOKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:10:04 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:53739 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1HVOKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:10:02 -0400
Date: Mon, 22 Aug 2011 16:07:45 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, olaf@aepfle.de,
        xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        horms@verge.net.au, vgoyal@redhat.com
Subject: Re: [PATCH 4/4] kexec/arch/i386: Add get_memory_ranges_xen() function
Message-ID: <20110822140745.GC27902@router-fw-old.local.net-space.pl>
References: <20110821135459.GE17323@router-fw-old.local.net-space.pl> <201108220001.24399.konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108220001.24399.konrad.wilk@oracle.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 12:01:24AM -0400, Konrad Rzeszutek Wilk wrote:

[...]

> > +#ifdef HAVE_LIBXENCTRL
> > +static unsigned e820_to_kexec_type(uint32_t type)
> > +{
> > +	switch (type) {
> > +		case E820_RAM:
> > +			return RANGE_RAM;
> > +		case E820_ACPI:
> > +			return RANGE_ACPI;
> > +		case E820_NVS:
> > +			return RANGE_ACPI_NVS;
> > +		case E820_RESERVED:
>
> For E820_UNUSABLE you want to do that too?
>
> > +		default:
> > +			return RANGE_RESERVED;
>
> Or should E820_UNUSABLE returne its own type of RANGE?

Kexec does not differentiate between E820_RESERVED and E820_UNUSABLE
(please look into kexec/firmware_memmap.c, parse_memmap_entry()).
It treats both as RANGE_RESERVED. RANGE_UNUSABLE is not defined.
In this situation I stated that it is not worth to change that
and I have mapped all undefined types to RANGE_RESERVED. It means
that E820_UNUSABLE is mapped to RANGE_RESERVED.

Daniel
