Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1BOAsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:48:24 -0500
Received: from blu0-omc1-s7.blu0.hotmail.com ([65.55.116.18]:65354 "EHLO
	blu0-omc1-s7.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab1BOAsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:48:21 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP40BE75C23253DAF196A5E96D30@phx.gbl>
Date: Mon, 14 Feb 2011 19:48:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matt Fleming <matt@console-pimps.org>,
        David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        peterz@infradead.org, will.newton@gmail.com, jbaron@redhat.com,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297707868.5226.189.camel@laptop> <1297718964.23343.75.camel@gandalf.stny.rr.com> <1297719576.23343.80.camel@gandalf.stny.rr.com> <20110214.134600.179933733.davem@davemloft.net> <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com> <BLU0-SMTP166A8555C791786059B0FF96D00@phx.gbl> <20110214230902.GM2256@linux.vnet.ibm.com> <BLU0-SMTP4599FAAD7330498472B87396D00@phx.gbl> <57049.94.211.195.167.1297729198.squirrel@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <57049.94.211.195.167.1297729198.squirrel@gate.crashing.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:47:00 up 313 days, 10:36,  5 users,  load average: 2.10, 1.89,
	1.86
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 15 Feb 2011 00:48:20.0228 (UTC) FILETIME=[0A772C40:01CBCCAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Segher Boessenkool (segher@kernel.crashing.org) wrote:
> >> What CPU family are we talking about here?  For cache coherent CPUs,
> >> cache coherence really is supposed to work, even for mixed atomic and
> >> non-atomic instructions to the same variable.
> >
> > I'm really curious to know which CPU families too. I've used git blame
> > to see where these lwz/stw instructions were added to powerpc, and it
> > points to:
> >
> > commit 9f0cbea0d8cc47801b853d3c61d0e17475b0cc89
> 
> > So let's ping the relevant people to see if there was any reason for
> > making these atomic read/set operations different from other
> > architectures in the first place.
> 
> lwz is a simple 32-bit load.  On PowerPC, such a load is guaranteed
> to be atomic (except some unaligned cases).  stw is similar, for stores.
> These are the normal insns, not ll/sc or anything.
> 
> At the time, volatile tricks were used to make the accesses atomic; this
> patch changed that.  Result is (or should be!) better code generation.
> 
> Is there a problem with it?

It seems fine then. It seems to be my confusion to think that Matt
referred to PowerPC in his statement. It's probably an unrelated
architecture.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
