Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1BNQOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:14:11 -0500
Received: from blu0-omc1-s35.blu0.hotmail.com ([65.55.116.46]:22291 "EHLO
	blu0-omc1-s35.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab1BNQOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:14:09 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP501881B538D618099DC9C396D00@phx.gbl>
Date: Mon, 14 Feb 2011 11:14:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop> <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins> <20110214160437.GB2840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110214160437.GB2840@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:12:10 up 313 days,  2:01,  7 users,  load average: 1.73, 1.66,
	1.64
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 16:14:07.0965 (UTC) FILETIME=[351570D0:01CBCC62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Mon, Feb 14, 2011 at 04:57:04PM +0100, Peter Zijlstra wrote:
> > On Mon, 2011-02-14 at 10:51 -0500, Jason Baron wrote:
> > > On Sat, Feb 12, 2011 at 07:47:45PM +0100, Peter Zijlstra wrote:
> > > > On Fri, 2011-02-11 at 22:38 +0100, Peter Zijlstra wrote:
> > > > > 
> > > > > So why can't we make that jump_label_entry::refcount and
> > > > > jump_label_key::state an atomic_t and be done with it? 
> > > > 
> > > > So I had a bit of a poke at this because I didn't quite understand why
> > > > all that stuff was as it was. I applied both Jason's patches and then
> > > > basically rewrote kernel/jump_label.c just for kicks ;-)
> > > > 
> > > > I haven't tried compiling this, let alone running it, but provided I
> > > > didn't actually forget anything the storage per key is now 16 bytes when
> > > > modules are disabled and 24 * (1 + mods) bytes for when they are
> > > > enabled. The old code had 64 + 40 * mods bytes.
> > > > 
> > > > I still need to clean up the static_branch_else bits and look at !x86
> > > > aside from the already mentioned bits.. but what do people think?
> > > > 
> > > > ---
> > > 
> > > Generally, I really like this! Its the direction I think the jump label
> > > code should be going. The complete removal of the hash table, makes the
> > > design a lot better and simpler. We just need to get some of the details
> > > cleaned up, and of course we need this to compile :) But I don't see any
> > > fundamental problems with this approach. 
> > > 
> > > Things that still need to be sorted out:
> > > 
> > > 1) Since jump_label.h, are included in kernel.h, (indirectly via the
> > > dynamic_debug.h) the atomic_t definitions could be problematic, since
> > > atomic.h includes kernel.h indirectly...so we might need some header
> > > magic.
> > 
> > Yes, I remember running into that when I did the jump_label_ref stuff,
> > some head-scratching is in order there.
> > 
> 
> yes. i suspect this might be the hardest bit of this...

I remember that atomic_t is defined in types.h now rather than atomic.h.
Any reason why you should keep including atomic.h from jump_label.h ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
