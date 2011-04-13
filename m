Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1DMA4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:56:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23633 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab1DMA4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VhS4XJ5/TusMi3vpcsQjZzdIPG8CDWnlggMbxRf8ouYTaj4bHARlLzp3lRVf3mP+p/
         mzL6rr5toxrgZ3FHUvrg==
Date: Tue, 12 Apr 2011 17:56:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris McDermott <lcm@linux.vnet.ibm.com>
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
In-Reply-To: <1302655746.8321.4001.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1104121752400.12609@chino.kir.corp.google.com>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com> <1302557371.7286.16607.camel@nimitz> <alpine.DEB.2.00.1104121719430.10966@chino.kir.corp.google.com> <1302655746.8321.4001.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Dave Hansen wrote:

> > That doesn't seem like an argument against this patch, it's an improper 
> > configuration unless the remote memory access has a latency of 2.1x that 
> > of a local access between those two nodes.  If that's the case, then it's 
> > accurately following the ACPI spec and the VM has made its policy decision 
> > to enable zone_reclaim_mode as a result.
> 
> Heh, if the kernel broke on every system that didn't follow _some_ spec,
> it wouldn't boot in very many places.
> 
> When you have a hammer, everything looks like a nail.  When you're a
> BIOS developer, you start thwacking at the kernel with munged ACPI
> tables instead of boot options.  Folks do this in the real world, and I
> think if we can't put their names and addresses next to the code that
> works around this, we might as well put the DMI strings of their
> hardware. :) 
> 

That's why I suggested doing away with RECLAIM_DISTANCE entirely, 
otherwise we are relying on the SLIT always being correct when we know 
it's not; the policy decision in the kernel as it stands now is that we 
want to enable zone_reclaim_mode when remote memory access takes longer 
than 2x that of a local access (3x with KOSAKI-san's patch), which is 
something we can actually measure at boot rather than relying on the BIOS 
at all.  Then we don't have to bother with DMI strings for specific pieces 
of hardware and can remove the existing ia64 and powerpc special cases.
