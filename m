Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0KKMGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:06:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41097 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab0KKMGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:06:18 -0500
Subject: Re: [Questions] How to run 'perf top' on ARM to profile kernel
 functions with modules loaded
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20101111091733.GA2929@pulham.picochip.com>
References: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
	 <AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
	 <20101111091733.GA2929@pulham.picochip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 13:06:16 +0100
Message-ID: <1289477176.2084.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 09:17 +0000, Jamie Iles wrote:
> On Thu, Nov 11, 2010 at 03:52:07PM +0800, Ming Lei wrote:
> > 2010/11/11 Ming Lei <tom.leiming@gmail.com>:
> > > Hi,
> > >
> > > 'perf top' can't display any functions when modules are loaded on ARM.
> > 
> > Sorry, should be can't display any kernel functions when modules are loaded
> > on ARM.
> I've noticed this myself and I spent a bit of time looking into it last week 
> but didn't get too far. I did wonder if it was something to do with the map 
> fixups after loading the modules. If you look at the raw events after a perf 
> record with 'perf report -D' then the last module has a size that takes it to 
> 0xFFFFFFFF which overlaps with the rest of the kernel symbols.
> 
> On x86 it looks like the modules are loaded after the kernel image in VM 
> unlike ARM.

Order shouldn't matter, but that overlap is very likely what kills it.
That module size is buggy.
