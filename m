Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1LNCg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:36:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54297 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LNCg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:36:57 -0500
Date: Tue, 13 Dec 2011 18:36:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Shi, Alex" <alex.shi@intel.com>
cc: Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <alpine.DEB.2.00.1112020842280.10975@router.home> <1323419402.16790.6105.camel@debian> <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com> <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, David Rientjes wrote:

> > > 	{
> > > 	        n->nr_partial++;
> > > 	-       if (tail == DEACTIVATE_TO_TAIL)
> > > 	-               list_add_tail(&page->lru, &n->partial);
> > > 	-       else
> > > 	-               list_add(&page->lru, &n->partial);
> > > 	+       list_add_tail(&page->lru, &n->partial);
> > > 	}
> > > 

2 machines (one netserver, one netperf) both with 16 cores, 64GB memory 
with netperf-2.4.5 comparing Linus' -git with and without this patch:

	threads		SLUB		SLUB+patch
	 16		116614		117213 (+0.5%)
	 32		216436		215065 (-0.6%)
	 48		299991		299399 (-0.2%)
	 64		373753		374617 (+0.2%)
	 80		435688		435765 (UNCH)
	 96		494630		496590 (+0.4%)
	112		546766		546259 (-0.1%)

This suggests the difference is within the noise, so this patch neither 
helps nor hurts netperf on my setup, as expected.
