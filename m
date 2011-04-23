Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1DWHuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 03:50:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:57292 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1DWHuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 03:50:21 -0400
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110423000010.GB9328@tassilo.jf.intel.com>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
	 <1303407662-15564-2-git-send-email-acme@infradead.org>
	 <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu>
	 <1303508226.4865.8.camel@laptop> <1303509293.4865.10.camel@laptop>
	 <1303513062.4865.20.camel@laptop>
	 <20110423000010.GB9328@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 23 Apr 2011 09:50:07 +0200
Message-ID: <1303545007.2298.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 17:00 -0700, Andi Kleen wrote:
> On Sat, Apr 23, 2011 at 12:57:42AM +0200, Peter Zijlstra wrote:
> > On Fri, 2011-04-22 at 23:54 +0200, Peter Zijlstra wrote:
> > > On Fri, 2011-04-22 at 23:37 +0200, Peter Zijlstra wrote:
> > > > The below needs filling out for !x86 (which I filled out with
> > > > unsupported events) and x86 needs the offcore bits fixed to auto select
> > > > between the two offcore events.
> > > 
> > > Urgh, so SNB has different MSR_OFFCORE_RESPONSE bits and needs another table.
> > 
> > Also, NHM offcore bits were wrong... it implemented _ACCESS as _HIT and
> 
> What is ACCESS if not a HIT?

An ACCESS is all requests for data that comes in, after which you either
HIT or MISS in which case you have to ask someone else down the line.

> > counted OTHER_CORE_HIT* as MISS even though its clearly documented as an
> > L3 hit.
> 
> When the other core owns the cache line it has to be fetched from there.
> That's not a LLC hit.

Then _why_ are they described in 30.6.1.3, table 30-15, as:

OTHER_CORE_HIT_SNP	 9	(R/W). L3 Hit: ....
OTHER_CORE_HITM		10	(R/W). L3 Hit: ...


