Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2B0REe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:04:34 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34737
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab2B0REd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:04:33 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:160.36.179.135;KIP:(null);UIP:(null);IPV:NLI;H:kedge3.utk.tennessee.edu;RD:kedge3.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 27 Feb 2012 12:04:27 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [PATCH] perf_event use rdpmc rather than rdmsr when possible in
 kernel
In-Reply-To: <1330359518.11248.72.camel@twins>
Message-ID: <alpine.DEB.2.00.1202271202430.1902@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1202201722120.2753@cl320.eecs.utk.edu>  <1330342762.11248.69.camel@twins>  <alpine.DEB.2.00.1202271051330.1902@cl320.eecs.utk.edu> <1330359518.11248.72.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012, Peter Zijlstra wrote:

> > I couldn't find another usable rdpmc() call in the kernel.  Should I add 
> > one?  I admit I hadn't thought that this might break VMs not expecting
> > rdpmc calls from the kernel. 
> 
> arch/x86/include/asm/msr.h
> 
> #define rdpmc(counter, low, high)                       \                                    
> do {                                                    \                                    
>         u64 _l = native_read_pmc((counter));            \                                    
>         (low)  = (u32)_l;                               \                                    
>         (high) = (u32)(_l >> 32);                       \                                    
> } while (0)

ugh I did multiple recursive greps, and definitely searched msr.h by
hand various times looking for that and I somehow missed it each time.

I'll update the patch.

Vince

