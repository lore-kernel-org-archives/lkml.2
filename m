Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1BNXw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:52:57 -0500
Received: from blu0-omc1-s31.blu0.hotmail.com ([65.55.116.42]:41636 "EHLO
	blu0-omc1-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab1BNXw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:52:56 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP40692195814CA4739BB0FB96D00@phx.gbl>
Date: Mon, 14 Feb 2011 18:52:49 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: David Miller <davem@davemloft.net>
CC: matt@console-pimps.org, rostedt@goodmis.org, peterz@infradead.org,
        will.newton@gmail.com, jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <20110214.134600.179933733.davem@davemloft.net> <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com> <BLU0-SMTP637B2E9372CFBF3A0B5B0996D00@phx.gbl> <20110214.152500.104069812.davem@davemloft.net> <20110214233405.GC17432@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110214233405.GC17432@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:50:36 up 313 days,  9:40,  4 users,  load average: 2.71, 2.18,
	1.73
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 23:52:55.0036 (UTC) FILETIME=[4C7F23C0:01CBCCA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * David Miller (davem@davemloft.net) wrote:
[...]
> > We can't wholesale to atomic_t because we do this on variables of
> > all sizes, not just 32-bit ones.
> > 
> > We do them on pointers in the networking for example.
> 
> We have atomic_long_t for this, but yeah, it would kind of suck to have
> to create
> 
> union {
> 	atomic_long_t atomic;
> 	void *ptr;
> }

Actually, using a union for this is probably one of the worse idea I've
had recently. Just casting the pointer to unsigned long and vice-versa,
using atomic_long_*() ops would do the trick. But let's wait and see if
it's really needed.

Thanks,

Mathieu

> 
> all around the place. Let's see if we can get to know which PowerPC
> processor family all this fuss is about, and where this rumour
> originates from.
> 
> Thanks,
> 
> Mathieu
> 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
