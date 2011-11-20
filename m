Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1KTCKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 21:10:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1KTCKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 21:10:02 -0500
Date: Sat, 19 Nov 2011 18:09:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Anton Arapov <anton@redhat.com>
Subject: Re: NUMA emulation x86_64: numa=fake parameter for custom nodes
 distance
In-Reply-To: <20111119003114.GA10179@stainedmachine.redhat.com>
Message-ID: <alpine.DEB.2.00.1111191806390.25103@chino.kir.corp.google.com>
References: <1321617308-4998-1-git-send-email-pholasek@redhat.com> <20111118115336.18de45a0.akpm@linux-foundation.org> <20111119003114.GA10179@stainedmachine.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011, Petr Holasek wrote:

> A lot of developers still have no access to large NUMA machines and 
> possibility of NUMA emulation could involve more of them to thinking
> about NUMA awareness of their apps/kernel code.
> 

That's a bogus argument, numa=fake already allows you to construct as 
large of a NUMA box as you want in a faked environment.  The distances 
have nothing to do with that.

The distances you're adding here are, by definition, incorrect because it 
doesn't respect the actual distance between physical nodes that numa=fake 
uses already.  If you're using numa=fake on an UMA machine, then the 
performance of the kernel will be just that, you won't actual see any 
introduced latency between fake nodes just by changing the distance.  So 
you're completely invalidating what internode distances actually mean.

I'd much rather see an option to fake the SLIT that could do all of this 
without limitation and would be possible to debug issues in the future.
