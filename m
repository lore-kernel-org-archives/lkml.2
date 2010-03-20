Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab0CTRwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:52:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618Ab0CTRwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:52:12 -0400
Date: Sat, 20 Mar 2010 10:47:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression, post-2.6.34-rc1][PATCH] x86 / perf: Fix suspend to
 RAM on HP nx6325
In-Reply-To: <1269106609.9440.529.camel@laptop>
Message-ID: <alpine.LFD.2.00.1003201043530.18017@i5.linux-foundation.org>
References: <201003201507.15358.rjw@sisk.pl> <1269106609.9440.529.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Mar 2010, Peter Zijlstra wrote:
>  
>  	cpuhw = &per_cpu(cpu_hw_events, cpu);
> +	if (!cpuhw)
> +		return;

How can an address-of expression be NULL?

Yes, 'per_cpu()' is magic, but it shouldn't be possible to be _that_ 
magic. It's rather against the whole C model.

		Linus
