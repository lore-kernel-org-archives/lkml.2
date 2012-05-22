Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2EVC6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:58:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33909 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2EVC6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:58:35 -0400
Date: Mon, 21 May 2012 19:58:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michael Neuling <mikey@neuling.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: PowerPC boot failures in next-20120521
In-Reply-To: <3120.1337655100@neuling.org>
Message-ID: <alpine.DEB.2.00.1205211954340.13522@chino.kir.corp.google.com>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au> <328.1337652722@neuling.org> <alpine.DEB.2.00.1205211924390.13682@chino.kir.corp.google.com> <2182.1337654352@neuling.org> <2246.1337654423@neuling.org> <alpine.DEB.2.00.1205211942540.29814@chino.kir.corp.google.com>
 <3120.1337655100@neuling.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Michael Neuling wrote:

> Sorry, got it... CONFIG_DEBUG_VM enabled below...
> 
> pid_max: default: 32768 minimum: 301
> Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
> Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
> Mount-cache hash table entries: 4096
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys devices
> Initializing cgroup subsys freezer
> POWER7 performance monitor hardware support registered
> ------------[ cut here ]------------
> kernel BUG at /scratch/mikey/src/linux-next/include/linux/gfp.h:318!

Yeah, this is what I was expecting, it's tripping on

	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES || !node_online(nid));

and slub won't pass nid < 0.  You're sure my patch is applied? :)
