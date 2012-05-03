Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab2ECV5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:57:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54640 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2ECV5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:57:41 -0400
Date: Thu, 3 May 2012 14:57:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
In-Reply-To: <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1205031454400.1631@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au> <4F9ABF9C.2070707@xenotime.net> <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com> <20120427132343.fbb443b9.akpm@linux-foundation.org> <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
 <20120427143646.8209627e.akpm@linux-foundation.org> <87fwbnag6u.fsf@skywalker.in.ibm.com> <alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com> <CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
 <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012, David Rientjes wrote:

> Is this a claim that memory-intensive workloads will have the exact same 
> performance with and without memcg enabled?

I've just run specjbb2005 three times on my system both with and without 
cgroup_disable=memory on the command line and it is consistently 1% faster 
without memcg.  If I add XX:+UseLargePages to the command line to use 
hugepages it's even larger.  So why must I incur this performance 
degradation if I simply want to control who may mmap hugepages out of the 
global pool?

The functionality to control this is pretty important if I want to ensure 
applications aren't able to infringe on the preallocated hugepages of a 
higher priority application for business goals.
