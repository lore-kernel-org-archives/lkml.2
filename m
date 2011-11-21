Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1KUUl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab1KUUl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:41:58 -0500
Date: Mon, 21 Nov 2011 21:41:34 +0100
From: Petr Holasek <pholasek@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Anton Arapov <anton@redhat.com>
Subject: Re: NUMA emulation x86_64: numa=fake parameter for custom nodes
 distance
Message-ID: <20111121204133.GA677@dhcp-27-244.brq.redhat.com>
References: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
 <20111118115336.18de45a0.akpm@linux-foundation.org>
 <20111119003114.GA10179@stainedmachine.redhat.com>
 <alpine.DEB.2.00.1111191806390.25103@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111191806390.25103@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011, David Rientjes wrote:

> Date: Sat, 19 Nov 2011 18:09:59 -0800 (PST)
> From: David Rientjes <rientjes@google.com>
> To: Petr Holasek <pholasek@redhat.com>
> cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
>  <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
>  <hpa@zytor.com>, linux-kernel@vger.kernel.org, x86@kernel.org, Anton
>  Arapov <anton@redhat.com>
> Subject: Re: NUMA emulation x86_64: numa=fake parameter for custom nodes
>  distance
> 
> On Sat, 19 Nov 2011, Petr Holasek wrote:
> 
> > A lot of developers still have no access to large NUMA machines and 
> > possibility of NUMA emulation could involve more of them to thinking
> > about NUMA awareness of their apps/kernel code.
> > 
> 
> That's a bogus argument, numa=fake already allows you to construct as 
> large of a NUMA box as you want in a faked environment.  The distances 
> have nothing to do with that.
> 
> The distances you're adding here are, by definition, incorrect because it 
> doesn't respect the actual distance between physical nodes that numa=fake 
> uses already.  If you're using numa=fake on an UMA machine, then the 
> performance of the kernel will be just that, you won't actual see any 
> introduced latency between fake nodes just by changing the distance.  So 
> you're completely invalidating what internode distances actually mean.
> 
> I'd much rather see an option to fake the SLIT that could do all of this 
> without limitation and would be possible to debug issues in the future.

This patch was designed as nothing more than helper for debugging/testing
purposes, e.g. when it is useful to have more values in exports than only
LOCAL_DISTANCEs. So that's the reason why it disregards former distances 
between physical nodes.

Faking the SLIT table is a really good point, if this patch would be 
eventually rejected, I will rework the patch in that manner.
