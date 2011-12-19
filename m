Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1LSOhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:37:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1LSOhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:37:35 -0500
Date: Mon, 19 Dec 2011 15:37:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
Message-ID: <20111219143706.GC1606@m.brq.redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
 <1324044159.18942.104.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324044159.18942.104.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 03:02:39PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-12-15 at 16:30 +0100, Jiri Olsa wrote:

SNIP

> > event_breakpoint:       PE_SEP_BP ':' PE_VALUE event_breakpoint_type modifier
> > event_breakpoint_type:  PE_MODIFIER_BPTYPE | empty
> > modifier:               PE_MODIFIER_EVENT | empty
> 
> This isn't complete, we need means of specifying
> perf_event_attr::config[12] when specifying a raw event.
ok

> 
> 

SNIP

> >                         cpu-migrations|migrations                      |
> >                         alignment-faults                               |
> >                         emulation-faults
> 
> It might make sense to allow means of custom symbol -> raw mappings.
>
right, will save some code..

> > PE_NAME_CACHE_TYPE:     L1-dcache|l1-d|l1d|L1-data             |
> >                         L1-icache|l1-i|l1i|L1-instruction      |
> >                         LLC|L2                                 |
> >                         dTLB|d-tlb|Data-TLB                    |
> >                         iTLB|i-tlb|Instruction-TLB             |
> >                         branch|branches|bpu|btb|bpc            |
> >                         node
> > 
> > PE_NAME_CACHE_OP_RESULT: load|loads|read                       |
> >                         store|stores|write                     |
> >                         prefetch|prefetches                    |
> >                         speculative-read|speculative-load      |
> >                         refs|Reference|ops|access              |
> >                         misses|miss
> > 
> > PE_SEP_RAW:             'r'
> > PE_SEP_BP:              'mem'
> > PE_MODIFIER_EVENT:      :[ukhp]{1,2}
> 
> You can actually have more than 2 modifiers, eg. "upp". 
> 
> [u] | [k] | [h] | [p]{,3} would be more correct I think.
yay, the boundaries are indeed [0,3], I thought it was bool..

	* precise_ip:
	*
	*  0 - SAMPLE_IP can have arbitrary
	*  skid
	*  1 - SAMPLE_IP must have constant
	*  skid
	*  2 - SAMPLE_IP requested to have 0
	*  skid
	*  3 - SAMPLE_IP must have 0 skid
	*

> 
> > PE_MODIFIER_BPTYPE:     :[rwx]{1,3}
> > PE_NAME_TP:             [a-zA-Z_*?]+
> > PE_VALUE:               number
> > 
> > Added flex/bison files for event grammar parsing. Added
> > flex/bison Makefile rules plus few special dependencies. 
> 
> It might be good to include the .c output of flex/bison so that we can
> build perf without a hard dependency on them -- only people changing the
> parser will need them.
ok

thanks,
jirka
