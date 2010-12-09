Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0LIVtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:49:24 -0500
Received: from www.tglx.de ([62.245.132.106]:56365 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab0LIVtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:49:23 -0500
Date: Thu, 9 Dec 2010 22:49:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 14/16] x86: Unify CPU -> NUMA node mapping between 32
 and 64bit
In-Reply-To: <1290871325-3055-15-git-send-email-tj@kernel.org>
Message-ID: <alpine.LFD.2.00.1012092244520.2653@localhost6.localdomain6>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-15-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Tejun Heo wrote:

> Unlike 64bit, 32bit has been using its own cpu_to_node_map[] for CPU
> -> NUMA node mapping.  Replace it with early_percpu variable
> x86_cpu_to_node_map and share the mapping code with 64bit.
> 
> * USE_PERCPU_NUMA_NODE_ID is now enabled for 32bit too.
> 
> * x86_cpu_to_node_map and numa_set/clear_node() are moved from numa_64
>   to numa.  For now, x86_cpu_to_node_map is initialized with 0 instead
>   of NUMA_NO_NODE.  This is to avoid introducing unexpected behavior

That's true for 32bit only, right? I actually had to dig into the code
to verify this. Please make this clear for the casual reader.

Thanks,

	tglx
