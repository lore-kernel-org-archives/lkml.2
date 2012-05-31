Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2EaRTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:19:53 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44012 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2EaRTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:19:51 -0400
Date: Thu, 31 May 2012 19:20:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531172018.GO14515@aftab.osrc.amd.com>
References: <4FBE5E1D.7070804@redhat.com>
 <20120524164554.GM27063@aftab.osrc.amd.com>
 <4FBE7755.2080301@redhat.com>
 <20120529115851.GB29157@aftab.osrc.amd.com>
 <4FC4D6E2.9060501@redhat.com>
 <20120529145245.GG29157@aftab.osrc.amd.com>
 <4FC4E9EB.5030801@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
 <20120531100005.GC14074@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6C61@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F6C61@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 04:51:27PM +0000, Luck, Tony wrote:
> No, it's a 6-bit field used as a shift ... so if it has value "6", it
> means cache line granularity. Value "12" would mean 4K granularity.
> Architecturally it could say "30" to mean gigabyte, or even "63" to
> mean "everything is gone".

Right, 0x3f are 6 bits, correct, doh!

> >> while a few (IIRC patrol scrub) will report with page (4K)
> >> granularity. Linux doesn't really care - they all have to get rounded
> >> up to page size because we can't take away just one cache line from a
> >> process.
> >
> > I'd like to see that :-)
> 
> Patrol scrub works inside the depths of the memory controller on rank/row
> addresses, not on system physical addresses. When it finds a problem, a
> reverse translation is needed to be able to report a system physical
> address in MCi_ADDR. Getting all the bits right is apparently a hard thing
> to do, so the MCI_MISC_ADDR_LSB bits are used to indicate that some low
> order bits are not valid.

Ok, thus the dynamic granularity. But we're going to end up reporting
rank and row too so that it can be matched to the DIMM. I consider
physical address a bonus in such cases and it is only of importance to
those who like to replace single DRAM chips or single MOSFET transistors
:-) :-) :-).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
