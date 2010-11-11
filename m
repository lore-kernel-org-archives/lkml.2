Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab0KKJRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:17:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46347 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0KKJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:17:38 -0500
Date: Thu, 11 Nov 2010 09:17:34 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Questions] How to run 'perf top' on ARM to profile kernel
 functions with modules loaded
Message-ID: <20101111091733.GA2929@pulham.picochip.com>
References: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
 <AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 03:52:07PM +0800, Ming Lei wrote:
> 2010/11/11 Ming Lei <tom.leiming@gmail.com>:
> > Hi,
> >
> > 'perf top' can't display any functions when modules are loaded on ARM.
> 
> Sorry, should be can't display any kernel functions when modules are loaded
> on ARM.
I've noticed this myself and I spent a bit of time looking into it last week 
but didn't get too far. I did wonder if it was something to do with the map 
fixups after loading the modules. If you look at the raw events after a perf 
record with 'perf report -D' then the last module has a size that takes it to 
0xFFFFFFFF which overlaps with the rest of the kernel symbols.

On x86 it looks like the modules are loaded after the kernel image in VM 
unlike ARM.

Jamie
