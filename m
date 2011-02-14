Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1BNQnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:43:52 -0500
Received: from blu0-omc1-s15.blu0.hotmail.com ([65.55.116.26]:52462 "EHLO
	blu0-omc1-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab1BNQnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:43:49 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP55B0369F59D9044E43B96C96D00@phx.gbl>
Date: Mon, 14 Feb 2011 11:43:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop> <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins> <20110214160437.GB2840@redhat.com> <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl> <1297700754.5226.110.camel@laptop> <20110214162947.GA3449@redhat.com> <1297701438.5226.113.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1297701438.5226.113.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:41:17 up 313 days,  2:30,  7 users,  load average: 2.05, 1.92,
	1.75
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 16:43:47.0997 (UTC) FILETIME=[5A10C4D0:01CBCC66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2011-02-14 at 11:29 -0500, Jason Baron wrote:
> > On Mon, Feb 14, 2011 at 05:25:54PM +0100, Peter Zijlstra wrote:
> > > > 
> > > > I remember that atomic_t is defined in types.h now rather than atomic.h.
> > > > Any reason why you should keep including atomic.h from jump_label.h ?
> > > 
> > > Ooh, shiny.. we could probably move the few atomic_{read,inc,dec} users
> > > in jump_label.h into out of line functions and have this sorted.
> > > 
> > 
> > inc and dec sure, but atomic_read() for the disabled case needs to be
> > inline....
> 
> D'0h yes of course, I was thinking about jump_label_enabled(), but
> there's still the static_branch() implementation to consider.
> 
> We could of course cheat implement our own version of atomic_read() in
> order to avoid the whole header mess, but that's not pretty at all
> 

OK, so the other way around then : why does kernel.h need to include
dynamic_debug.h (which includes jump_label.h) ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
