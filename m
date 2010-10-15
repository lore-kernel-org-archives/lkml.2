Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0JOJMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:12:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:33582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0JOJM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hEAH/jRxgoTyh+HRJdCXnrpcCbKGw7DhPIgV/cugOMpM596TxS0foHvWLqC+S4ehAh
         Gz1cMRWFHuCebO2KdQ8Q==
Date: Fri, 15 Oct 2010 02:11:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <20101015031014.GC9640@elte.hu>
Message-ID: <alpine.DEB.2.00.1010150209550.8103@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <20101014011056.a58bac55.akpm@linux-foundation.org> <alpine.DEB.2.00.1010141509270.3696@chino.kir.corp.google.com> <20101014153223.a710d70c.akpm@linux-foundation.org>
 <20101015031014.GC9640@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, Ingo Molnar wrote:

> Can we automate it perhaps? Drivers could express their zone needs, and 
> perhaps we can free up the zone if there's no relevant driver loaded by 
> the time we have booted up? If a hotplug driver arrives later on, is the 
> MM good enough for us to be able to reinstate the zone dynamically?
> 

That's the same as setting /proc/sys/vm/lowmem_reserve_ratio to 0 for all 
zones so that no lowmem is reserved specifically for DMA allocations.  
Then, ZONE_DMA becomes like any other zone and is open to all allocations.
