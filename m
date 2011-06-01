Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab1FATJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:09:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17216 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab1FATJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Oszl/WuYLI82CBSlaJWaVrtlvQb0wI0oqh0gam7/btnH4NeaM9TDsJn9hRkjd8VDe1
         pyVwn1EFOjvRoeh3r6tA==
Date: Wed, 1 Jun 2011 12:09:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
In-Reply-To: <alpine.LFD.2.02.1106012043080.3078@ionos>
Message-ID: <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com> <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>
 <20110601181918.GO3660@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1106012043080.3078@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Thomas Gleixner wrote:

> > That is NOT an unreasonable request, but it seems that its far too much
> > to ask of you.
> 
> Full ack.
> 
> David,
> 
> stop that nonsense already. You changed the behaviour and broke stuff
> which was working fine before for whatever reason. That behaviour was
> in the kernel for ages and we tolerated the abuse.
> 

Did I nack this patch and not realize it?

Does my patch fix the warning for pxaficp_ir that would still be emitted 
with this patch?  If the driver uses GFP_DMA and nobody from the arm side 
is prepared to remove it yet, then I'd suggest merging my patch until that 
can be determined.  Otherwise, you have no guarantees about where the 
memory is actually coming from.
