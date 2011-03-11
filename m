Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1CKCjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:39:17 -0500
Received: from blu0-omc1-s12.blu0.hotmail.com ([65.55.116.23]:10493 "EHLO
	blu0-omc1-s12.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158Ab1CKCjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:39:14 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP8711FDC58A80D77733924496CB0@phx.gbl>
Date: Thu, 10 Mar 2011 21:39:08 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ralf Baechle <ralf@linux-mips.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <1299780241.15854.393.camel@gandalf.stny.rr.com> <20110310182000.GB2906@redhat.com> <1299782143.15854.402.camel@gandalf.stny.rr.com> <4D791CAA.7090108@caviumnetworks.com> <1299783236.15854.405.camel@gandalf.stny.rr.com> <4D791F31.6040100@caviumnetworks.com> <1299785143.15854.407.camel@gandalf.stny.rr.com> <1299786329.15854.409.camel@gandalf.stny.rr.com> <BLU0-SMTP39EE03AE86CF0F0E5C570596C80@phx.gbl> <20110311003846.GA23548@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110311003846.GA23548@linux-mips.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 21:36:20 up 337 days, 12:25,  5 users,  load average: 1.00, 0.69,
	0.62
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Mar 2011 02:39:12.0940 (UTC) FILETIME=[81B476C0:01CBDF95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Baechle (ralf@linux-mips.org) wrote:
> On Thu, Mar 10, 2011 at 04:22:14PM -0500, Mathieu Desnoyers wrote:
> 
> > You seem to be contradicting yourself here. I'm concerned about having
> > "structures" of a size not power of two. Can we simply either
> > 
> > - Add a padding element at the end
> > or
> > - use .align 4*sizeof(long) at the beginning
> > 
> > to make sure the linker won't put any holes when it puts objects 
> > together ?
> 
> It may only be a technicality but but careful with .align.  On some
> architectures .align x will align to a multiple of x; on other
> architectures to 2^x.  Another reason to stick to C wherever possible.

Thanks for the reminder! Not sure if using C is practical in the case of
jump labels though. As Michael pointed out, using .balign might be
better here.

Mathieu

> 
>   Ralf

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
