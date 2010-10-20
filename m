Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0JTAXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:23:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51489 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab0JTAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:23:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Oct 2010 09:17:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: steve@digidescorp.com
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] nommu: add anonymous page memcg accounting
Message-Id: <20101020091746.f0cc5dc2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287512657.2500.31.camel@iscandar.digidescorp.com>
References: <1287491654-4005-1-git-send-email-steve@digidescorp.com>
	<20101019154819.GC15844@balbir.in.ibm.com>
	<1287512657.2500.31.camel@iscandar.digidescorp.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 13:24:17 -0500
"Steven J. Magnani" <steve@digidescorp.com> wrote:

> On Tue, 2010-10-19 at 21:18 +0530, Balbir Singh wrote:
> > * Steven J. Magnani <steve@digidescorp.com> [2010-10-19 07:34:14]:
> > 
> > > Add the necessary calls to track VM anonymous page usage (only).
> > > 
> > > V2 changes:
> > > * Added update of memory cgroup documentation
> > > * Clarify use of 'file' to distinguish anonymous mappings
> > > 
> > > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> > > ---
> > > diff -uprN a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> > > --- a/Documentation/cgroups/memory.txt	2010-10-05 09:14:36.000000000 -0500
> > > +++ b/Documentation/cgroups/memory.txt	2010-10-19 07:28:04.000000000 -0500
> > > @@ -34,6 +34,7 @@ Current Status: linux-2.6.34-mmotm(devel
> > > 
> > >  Features:
> > >   - accounting anonymous pages, file caches, swap caches usage and limiting them.
> > > +   NOTE: On NOMMU systems, only anonymous pages are accounted.
> > >   - private LRU and reclaim routine. (system's global LRU and private LRU
> > >     work independently from each other)
> > >   - optionally, memory+swap usage can be accounted and limited.
> > > @@ -640,7 +641,30 @@ At reading, current status of OOM is sho
> > >  	under_oom	 0 or 1 (if 1, the memory cgroup is under OOM, tasks may
> > >  				 be stopped.)
> > > 
> > > -11. TODO
> > > +11. NOMMU Support
> <snip>
> > > +
> > > +At the present time, only anonymous pages are included in NOMMU memory cgroup
> > > +accounting.
> > 
> > What is the reason for tracking just anonymous memory?
> 
> Tracking more than that is beyond my current scope, and perhaps of
> limited benefit under an assumption that NOMMU systems don't usually
> work with large files. The limitations of the implementation are
> documented, so hopefully anyone who needs more functionality will know
> that they need to implement it.
> 

What happens at reaching limit ? memory can be reclaimed ?

Thanks,
-Kame


