Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0JNAuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:50:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54701 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0JNAuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PVzBj008CRVVivgJeO8pr8jB3q1IXYtcZq8MvvR2hb4Bkx2sPug4Khs8hFeK3VXKeV
         J7OAIiKOkttLdjwZmhEg==
Date: Wed, 13 Oct 2010 17:49:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <4CB65262.3070507@zytor.com>
Message-ID: <alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <4CB64D8F.9080800@zytor.com> <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com> <4CB65262.3070507@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, H. Peter Anvin wrote:

> > You can already set the lowmem_reserve_ratio via 
> > /proc/sys/vm/lowmem_reserve_ratio.
> 
> And why is it then so hard to put in a single line in /etc/sysctl.conf
> for you?
> 

Because disabling CONFIG_ZONE_DMA allows for additional extensions: 
disabling CONFIG_GENERIC_ISA_DMA and CONFIG_ISA_DMA_API.  We've also run 
for a couple years without those.

> > We've run without ZONE_DMA for a couple years because we don't have such 
> > hardware limitations and would appreciate the ability to disable it with a 
> > config option rather than hacking the kernel to get it to compile.  I'm 
> > sure Casey would as well as you can see in the thread "A question about 
> > ZONE_DMA".
> > 
> > I don't see the harm in being able to conveniently disable the zone if you 
> > know what you're doing.
> 
> There are going to be a lot of very strange bug reports as a result.
> 

We have config options all over the kernel that change the behavior of 
syscalls without worrying about bug reports popping up from users who 
knowingly have disabled the option, I don't see this as being any 
different.  If you're concerned about, we could add a

#ifndef CONFIG_ZONE_DMA
	WARN_ON_ONCE(gfp_mask & __GFP_DMA);
#endif

in the page allocator.
