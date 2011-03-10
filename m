Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1CJOLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:11:46 -0500
Received: from blu0-omc1-s15.blu0.hotmail.com ([65.55.116.26]:26390 "EHLO
	blu0-omc1-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab1CJOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:11:44 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP618D94A58771D9533EB21896C80@phx.gbl>
Date: Thu, 10 Mar 2011 09:11:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <cover.1299702291.git.jbaron@redhat.com> <1299728191.15854.319.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1299728191.15854.319.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:02:23 up 336 days, 23:52,  5 users,  load average: 0.16, 0.24,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Mar 2011 14:11:43.0716 (UTC) FILETIME=[157BFA40:01CBDF2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:
> > Hi,
> > 
> > Re-fresh of updates against latest -tip tree.
> 
> Thanks Jason,
> 
> I started looking at them, I should have comments tomorrow (if I have
> any comments ;)
> 
> > 
> > I've tried to split this update up somewhat, but I've only succeeded to split
> > out the dynamic debug bits. The interface changes and re-write are quite
> > intertwined.
> > 
> > I believe this update should address all the comments from the previous posting
> > except for Mathieu's request for a section of jump label pointers that point to
> > the jump label structures (since the compiler might leave gaps in the jump label
> > structures).
> 
> The jump label structures is a list of 3 pointers, correct? I doubt that
> gcc would place any holes in it as they are all aligned by natural word
> size.
> 

Hi Steven,

Can you explain what would prevent gcc from aligning these 3 pointers
(total of 24 bytes on 64-bit architectures) on 32-bytes ? Also, could
you point out what would refrain the linker from aligning the start of
object sections on the next 32-bytes (thus power of two) address
multiple ?

I think we need to be a bit more strict in our interpretation of what
guarantee gcc/ld provide and don't provide with respect to section and
structure alignment.

As it stands now, the section alignment of jump labels looks half-broken
on most architectures, and this *is* a big deal. I would really like to
see a patch for this (it can be a separate patch) going in for .39.

Thank you,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
