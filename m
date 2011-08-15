Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1HOO3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:29:47 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:49128 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753020Ab1HOO3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:29:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jOIEuVwVM1kziYTZFHbOV4ycfo7nFq1V8kUNLUbTZrdr_1X
 VfeN91RmqgnIP2By3vOSX18GwQJsyi_aUoT2xsJLOPOWXMZGjkHd971xVkl3
 LZVJZrVT6BniFZZ3Vm8HlR8__9tHwFAKfFRAa2fU6MBcR_G2kN7LsKwxf0eT
 rMKiE3wpa.HbxE0OntpR2Eo7G.k0OwpD7jh9qLFPswFX8q3DWofKzsv4dsc_
 paa7i.WAt_GImmetNibl5kT0Suv.X8w8msujekwPULEO.khR2hTPC9UE88rY
 Mq1JQQg.xjtP67NdynO_7oFjojBlnoc1HkHGQaM7l9rismb5eDSfDJGnrDO5
 oBKPQsL3iKPoAo4fta6qJsrDtMmHQxdPaQWClLTcxFkUVDg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 15 Aug 2011 09:29:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p4 0/7] slub: per cpu partial lists V4
In-Reply-To: <alpine.DEB.2.00.1108131118001.32762@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1108150928200.24941@router.home>
References: <20110809211221.831975979@linux.com> <alpine.DEB.2.00.1108131118001.32762@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Aug 2011, David Rientjes wrote:

> I'm currently 35,000 feet above Chicago going about 611 mph, so what
> better time to benchmark this patchset on my netperf testing rack!
>
> 	threads		before		after
> 	 16		78031		74714  (-4.3%)
> 	 32		118269		115810 (-2.1%)
> 	 48		150787		150165 (-0.4%)
> 	 64		189932		187766 (-1.1%)
> 	 80		221189		223682 (+1.1%)
> 	 96		239807		246222 (+2.7%)
> 	112		262135		271329 (+3.5%)
> 	128		273612		286782 (+4.8%)
> 	144		280009		293943 (+5.0%)
> 	160		285972		299798 (+4.8%)

The higher the contention the better the performance. But the -4% on non
contention is worrisome.
