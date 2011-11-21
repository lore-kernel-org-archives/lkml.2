Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1KUWYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:24:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63716 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1KUWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:24:22 -0500
Date: Mon, 21 Nov 2011 14:24:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Anton Arapov <anton@redhat.com>
Subject: Re: NUMA emulation x86_64: numa=fake parameter for custom nodes
 distance
In-Reply-To: <20111121204133.GA677@dhcp-27-244.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.1111211416000.5318@chino.kir.corp.google.com>
References: <1321617308-4998-1-git-send-email-pholasek@redhat.com> <20111118115336.18de45a0.akpm@linux-foundation.org> <20111119003114.GA10179@stainedmachine.redhat.com> <alpine.DEB.2.00.1111191806390.25103@chino.kir.corp.google.com>
 <20111121204133.GA677@dhcp-27-244.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Petr Holasek wrote:

> This patch was designed as nothing more than helper for debugging/testing
> purposes, e.g. when it is useful to have more values in exports than only
> LOCAL_DISTANCEs. So that's the reason why it disregards former distances 
> between physical nodes.
> 

I understand, but like I said: the only debugging and testing it would be 
useful for is node ordering.  The actual latency of memory accesses are 
not going to be representative of the new distances and will lead to 
confusion since they're wrong.  It's also pretty limited in even that 
regard because all nodes are now spaced by the same distance so they're 
just spread out linearly instead of actually representing a real NUMA 
architecture.

> Faking the SLIT table is a really good point, if this patch would be 
> eventually rejected, I will rework the patch in that manner.
> 

That has applicability even outside of debugging, you could override your 
own machine's slit if you know it's bogus.  The way it's defined is very 
lengthy, however, and would require (4 * nr_nodes^2) characters at maximum 
since the max distance is three characters, 255 (unreachable node), and 
you'd need to separate them by one character, a comma.  That's 256 chars 
for eight nodes!
