Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0K3Roj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:44:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:65066 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0K3Roi (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 30 Nov 2010 12:44:38 -0500
Date: Tue, 30 Nov 2010 12:43:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Idea: Make drivers/char/agp/*.c use the PCI API.
Message-ID: <20101130174325.GA10507@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

I am working on getting Linux Xen PV guests to be able to use graphics card.
The crux of the problem I am running into is that any of the 'page_to_phys'
or 'virt_to_phys' macros under Xen return a PFN which is actually not the 
_real_ PFN (called Machine Frame Number, MFN in Xen terminology). So when
we program the GATT bus address, the PFN of the GATT != MFN. Hence the bridge
ends up looking for the GATT somewhere completely different than what we expected.

In the past I've inserted some nasty skanky lookup code to in drivers/char/agp/*.c
so that the GATT bus address, and the bus addresses of the pages that are to be
mapped to the GATT get the MFN - but that was a band-aid solution.

I was wondering what you guys thought if I reworked the drivers/char/agp to use
the PCI API, similarly to what drivers/char/agp/intel-gtt.c is doing right now.
Perhaps even go further and squash the intel-gtt.c scatter-list usage into the
generic.c. Other ideas?

I've some of the old hardware laying around so I can definitly test some subset
of the hardware. Are there some particular ones I should look for that had
trouble?

