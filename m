Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0E1BMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:12:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919Ab0E1BMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:12:30 -0400
Date: Thu, 27 May 2010 18:09:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: linux-next: build failure in Linus' tree
In-Reply-To: <20100528105719.a356ba4f.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1005271807470.11382@i5.linux-foundation.org>
References: <20100528105719.a356ba4f.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 May 2010, Stephen Rothwell wrote:
> 
> Caused by commit 0ac0c0d0f837c499afd02a802f9cf52d3027fa3b ("cpusets:
> randomize node rotor used in cpuset_mem_spread_node()").
> 
> This commit assumes that __node_random() exists if (MAX_NUMNODES > 1) and
> uses it if CONFIG_CPUSETS is set, but only creates it for x86 ...  there
> is at least one other architecture where those conditions are true.

Yeah, looking at that, it seems totally idiotic.

Why is that "__node_random()" in x86 code at all? There is absolutely 
nothing x86 about it that I can tell. And now I have an ia64 merge that 
just duplicates that moronic function.

		Linus
