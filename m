Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab1DWAAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:00:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:23709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab1DWAAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:00:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="632859688"
Date: Fri, 22 Apr 2011 17:00:10 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110423000010.GB9328@tassilo.jf.intel.com>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <1303508226.4865.8.camel@laptop>
 <1303509293.4865.10.camel@laptop>
 <1303513062.4865.20.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303513062.4865.20.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 12:57:42AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-04-22 at 23:54 +0200, Peter Zijlstra wrote:
> > On Fri, 2011-04-22 at 23:37 +0200, Peter Zijlstra wrote:
> > > The below needs filling out for !x86 (which I filled out with
> > > unsupported events) and x86 needs the offcore bits fixed to auto select
> > > between the two offcore events.
> > 
> > Urgh, so SNB has different MSR_OFFCORE_RESPONSE bits and needs another table.
> 
> Also, NHM offcore bits were wrong... it implemented _ACCESS as _HIT and

What is ACCESS if not a HIT?

> counted OTHER_CORE_HIT* as MISS even though its clearly documented as an
> L3 hit.

When the other core owns the cache line it has to be fetched from there.
That's not a LLC hit.

-Andi
