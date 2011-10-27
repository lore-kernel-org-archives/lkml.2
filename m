Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1J0UIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:08:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1J0UIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:08:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=BMNo6HCgUKaT75o5qRiMvfMuoS158vpcLT+yX/oWkLmDGtyAv1XvreWkpUPvMQFBo
	rSM8TEe9cDf4BNtd5Nuiw==
Date: Thu, 27 Oct 2011 13:08:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Philipp Herz - Profihost AG <p.herz@profihost.ag>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        s.priebe@profihost.ag
Subject: Re: Vanilla-Kernel 3 - page allocation failure
In-Reply-To: <4EA9047C.5060604@profihost.ag>
Message-ID: <alpine.DEB.2.00.1110271302330.7639@chino.kir.corp.google.com>
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org> <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com> <4EA506B9.4030604@profihost.ag> <alpine.DEB.2.00.1110261322460.23111@chino.kir.corp.google.com>
 <4EA9047C.5060604@profihost.ag>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011, Philipp Herz - Profihost AG wrote:

> > It won't be triggered synchronously in this context since it's a
> > GFP_ATOMIC allocation, which is why it emits a page allocation failure in
> > the first place, but it will show whether defragmentation is the issue or
> > you're just simply low on memory.
> Do you mean that "memory compaction" should be turned off again?
> 

No, I mean the difference since 2.6.32 might be that lumpy reclaim was 
deprecated so it is no longer causing high-order page allocations to be 
free in atomic context where no balancing or migration can synchronously 
be done.

> How can I see the difference between "deframentation issue" and "low memory"?
> I did not get this point.
> 

unusable_index and extfrag_index in debugfs if you've enabled and mounted 
that.  You could also take a look at tweaking 
/proc/sys/vm/extfrag_threshold, see Documentation/sysctl/vm.txt.
