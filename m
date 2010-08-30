Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0H3ReB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:34:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59470 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0H3ReA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:34:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #16399] perf failed with kernel 2.6.35-rc
Date: Mon, 30 Aug 2010 19:32:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.XtC.eeueMB@chimera> <1283159563.1820.665.camel@laptop>
In-Reply-To: <1283159563.1820.665.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301932.21073.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 30, 2010, Peter Zijlstra wrote:
> On Mon, 2010-08-30 at 01:13 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16399
> > Subject		: perf failed with kernel 2.6.35-rc
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2010-07-13 8:14 (48 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
> > Message-ID	: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
> > References	: http://marc.info/?l=linux-kernel&m=127900880212470&w=2
> > 
> > 
> 
> Should be fixed by:
> 
> commit 351af0725e5222e35741011d1ea62215c1ed06db
> Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date:   Fri Aug 6 13:39:08 2010 +0800
> 
>     perf, x86: Fix Intel-nhm PMU programming errata workaround                                                                                                        
>                                                                                                                                                                       
>     Fix the Errata AAK100/AAP53/BD53 workaround, the officialy documented                                                                                             
>     workaround we implemented in:                                                                                                                                     
>                                                                                                                                                                       
>      11164cd: perf, x86: Add Nehelem PMU programming errata workaround                                                                                                
>                                                                                                                                                                       
>     doesn't actually work fully and causes a stuck PMU state                                                                                                          
>     under load and non-functioning perf profiling.                                                                                                                    
>                                                                                                                                                                       
>     A functional workaround was found by trial & error.                                                                                                               
>                                                                                                                                                                       
>     Affects all Nehalem-class Intel PMUs.                                                                                                                             
>                                                                                                                                                                       
>     Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>                                                                                                        
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>                                                                                                            
>     LKML-Reference: <1281073148.2125.63.camel@ymzhang.sh.intel.com>                                                                                                   
>     Cc: Arjan van de Ven <arjan@linux.intel.com>                                                                                                                      
>     Cc: "H. Peter Anvin" <hpa@zytor.com>                                                                                                                              
>     Cc: <stable@kernel.org> # .35.x                                                                                                                                   
>     Signed-off-by: Ingo Molnar <mingo@elte.hu> 

Thanks, closed.

Rafael
