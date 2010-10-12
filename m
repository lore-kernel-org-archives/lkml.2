Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0JLAOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:14:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54545 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0JLAOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:14:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Oct 2010 09:09:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jack Steiner <steiner@sgi.com>
Cc: yinghai@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Problem: scaling of /proc/stat on large systems
Message-Id: <20101012090907.5dd1cf57.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101008163557.GA13859@sgi.com>
References: <20100929122206.GA30317@sgi.com>
	<20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com>
	<20101004143414.GA4261@sgi.com>
	<20101005103650.7ebe64f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20101005171907.23c75102.kamezawa.hiroyu@jp.fujitsu.com>
	<20101008163557.GA13859@sgi.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 11:35:57 -0500
Jack Steiner <steiner@sgi.com> wrote:

> On Tue, Oct 05, 2010 at 05:19:07PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 5 Oct 2010 10:36:50 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > I guess this requres different approarch as per-cpu counter + threshould.
> > > like vmstat[] or lib/percpu_counter. 
> > > Maybe people don't like to access shared counter in IRQ.
> > > 
> > > But, this seems to call radixtree-lookup for the # of possible cpus.
> > > I guess impleimenting a call to calculate a sum of irqs in a radix-tree
> > > lookup will reduce overhead. If it's not enough, we'll have to make the
> > > counter not-precise. I'll write an another patch.
> > > 
> > 
> > How about this ? This is an add-on patch.
> 
> Nice!!
> 
> The combination of the 2 patches solves the problem.
> The timings are (4096p, 256 nodes, 4592 irqs):
> 
> 	# time cat /proc/stat > /dev/null
> 
> 	Baseline:		12.627 sec
> 	Patch1  :		 2.459 sec
> 	Patch 1 + Patch 2:	  .561 sec
> 
> 
> Acked-by: Jack Steiner <steiner@sgi.com>
> 

Thank you for testing. I'll post again if necessary.

-Kame


