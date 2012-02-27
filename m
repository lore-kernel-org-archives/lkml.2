Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2B0QS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:18:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48234 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2B0QS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:18:56 -0500
Message-ID: <1330359518.11248.72.camel@twins>
Subject: Re: [PATCH] perf_event use rdpmc rather than rdmsr when possible in
 kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Date: Mon, 27 Feb 2012 17:18:38 +0100
In-Reply-To: <alpine.DEB.2.00.1202271051330.1902@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1202201722120.2753@cl320.eecs.utk.edu>
	 <1330342762.11248.69.camel@twins>
	 <alpine.DEB.2.00.1202271051330.1902@cl320.eecs.utk.edu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 11:06 -0500, Vince Weaver wrote:
> > > +   new_raw_count=native_read_pmc(hwc->event_base_rdpmc);
> > 
> > That really wants to be rdpmc(), bypassing paravirt like that isn't
> > nice.
> 
> I couldn't find another usable rdpmc() call in the kernel.  Should I add 
> one?  I admit I hadn't thought that this might break VMs not expecting
> rdpmc calls from the kernel. 

arch/x86/include/asm/msr.h

#define rdpmc(counter, low, high)                       \                                    
do {                                                    \                                    
        u64 _l = native_read_pmc((counter));            \                                    
        (low)  = (u32)_l;                               \                                    
        (high) = (u32)(_l >> 32);                       \                                    
} while (0)

