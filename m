Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab0K1BhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 20:37:08 -0500
Received: from smtp-out.google.com ([74.125.121.35]:1090 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0K1BhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 20:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uqu3tXUL0dCc+2OePO9SUOblBx5Vb/8s+qlbUFszq8b1vvBfjahxEHH1zcBMI5ZZAa
         uCI/3IhOb4Kzzs9Jbc1A==
Date: Sat, 27 Nov 2010 17:36:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should
 get bonus
In-Reply-To: <20101123154843.7B8D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011271733460.3764@chino.kir.corp.google.com>
References: <20101115095446.BF00.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150159330.2986@chino.kir.corp.google.com> <20101123154843.7B8D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, KOSAKI Motohiro wrote:

> > > > I think in cases of heuristics like this where we obviously want to give 
> > > > some bonus to CAP_SYS_ADMIN that there is consistency with other bonuses 
> > > > given elsewhere in the kernel.
> > > 
> > > Keep comparision apple to apple. vm_enough_memory() account _virtual_ memory.
> > > oom-killer try to free _physical_ memory. It's unrelated.
> > > 
> > 
> > It's not unrelated, the LSM function gives an arbitrary 3% bonus to 
> > CAP_SYS_ADMIN.  
> 
> Unrelated. LSM _is_ security module. and It only account virtual memory.
> 

I needed a small bias for CAP_SYS_ADMIN tasks so I chose 3% since it's the 
same proportion used elsewhere in the kernel and works nicely since the 
badness score is now a proportion.  If you'd like to propose a different 
percentage or suggest removing the bias for root tasks altogether, feel 
free to propose a patch.  Thanks!
