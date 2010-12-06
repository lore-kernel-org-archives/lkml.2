Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0LFSLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:11:46 -0500
Received: from waste.org ([173.11.57.241]:43327 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0LFSLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:11:45 -0500
Subject: Re: [cpuops inc_return V1 8/9] random: Use this_cpu_inc_return
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101206174017.684979312@linux.com>
References: <20101206173958.685460926@linux.com>
	 <20101206174017.684979312@linux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 12:11:42 -0600
Message-ID: <1291659102.3065.2212.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 11:40 -0600, Christoph Lameter wrote:
> plain text document attachment (cpuops_inc_return_random)
> __this_cpu_inc can create a single instruction to do the same as
> __get_cpu_var()++.

> -	    (__get_cpu_var(trickle_count)++ & 0xfff))
> +	    ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff))

I see you've added a "- 1" to mimic the post-increment ++ semantic.

The goal of this code to add only 1 sample in every 4096, but we don't
really care which, so this semantic isn't actually important here.

-- 
Mathematics is the supreme nostalgia of our time.


