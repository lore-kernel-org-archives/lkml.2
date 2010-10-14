Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0JNAmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:42:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28395 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0JNAmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:42:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JDRlbv/nwlLrMLDcJ6SEm4mrZbzjPKYGmaNjdJkZz19v3sUDNwFAlf1S3OSZMFNaZM
         dqTFDExrCAax1fNI7KAQ==
Date: Wed, 13 Oct 2010 17:42:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <4CB64D8F.9080800@zytor.com>
Message-ID: <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <4CB64D8F.9080800@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, H. Peter Anvin wrote:

> > ZONE_DMA is unnecessary for a large number of machines that do not
> > require addressing in the lower 16MB of memory because they do not use
> > ISA devices with 16-bit address registers (plus one page byte register).
> > 
> > This patch allows users to disable ZONE_DMA for x86 if they know they
> > will not be using such devices with their kernel.
> > 
> > This prevents the VM from unnecessarily reserving a ratio of memory
> > (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> > for such allocations when it will never be used.
> 
> This isn't true.
> 
> There are many, many devices other than ISA devices which need access to
> a restricted-memory pool because of hardware DMA limitations.  This
> seems like a really bad idea.
> 
> A much better idea would be to have a runtime option of setting the
> reservation ratio, if recovering no more than 1/66th of a gigabyte
> matters so much to you.
> 

You can already set the lowmem_reserve_ratio via 
/proc/sys/vm/lowmem_reserve_ratio.

We've run without ZONE_DMA for a couple years because we don't have such 
hardware limitations and would appreciate the ability to disable it with a 
config option rather than hacking the kernel to get it to compile.  I'm 
sure Casey would as well as you can see in the thread "A question about 
ZONE_DMA".

I don't see the harm in being able to conveniently disable the zone if you 
know what you're doing.
