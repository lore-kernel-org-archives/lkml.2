Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab1FJWQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:16:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2681 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=X3uOovUAFCS8WMU8xoPVFt6dfJ7y+CJAN0Yn3Fcx3MUyGAPg7sXst2YWHoqZIIqFxv
         gylRi3UHi50ZoAC+DFAg==
Date: Fri, 10 Jun 2011 15:16:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
In-Reply-To: <20110610220748.GO24424@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1106101510000.23076@chino.kir.corp.google.com>
References: <alpine.LFD.2.02.1106012043080.3078@ionos> <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com> <alpine.LFD.2.02.1106012134120.3078@ionos> <4DF1C9DE.4070605@jp.fujitsu.com> <20110610004331.13672278.akpm@linux-foundation.org>
 <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com> <20110610091233.GJ24424@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1106101150280.17197@chino.kir.corp.google.com> <20110610185858.GN24424@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1106101456080.23076@chino.kir.corp.google.com>
 <20110610220748.GO24424@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Russell King - ARM Linux wrote:

> > We're talking about two different things.  Linus is saying that if GFP_DMA 
> > should be a no-op if the hardware doesn't require DMA memory because the 
> > kernel was correctly compiled without CONFIG_ZONE_DMA.  I'm asking about a 
> > kernel that was incorrectly compiled without CONFIG_ZONE_DMA and now we're 
> > returning memory from anywhere even though we actually require GFP_DMA.
> 
> How do you distinguish between the two states?  Answer: you can't.
> 

By my warning which says "enable CONFIG_ZONE_DMA _if_ needed."  The 
alternative is to silently return memory from anywhere, which is what the 
page allocator does now, which doesn't seem very user friendly when the 
device randomly works depending on the chance it was actually allocated 
from the DMA mask.  If it actually wants DMA and the kernel is compiled 
incorrectly, then I think a single line in the kernel log would be nice to 
point them in the right direction.  Users who disable the option usually 
know what they're doing (it's only allowed for CONFIG_EXPERT on x86, for 
example), so I don't think they'll mind the notification and choose to 
ignore it.
