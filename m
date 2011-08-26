Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1HZJAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:00:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52008 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1HZJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:00:20 -0400
Date: Fri, 26 Aug 2011 11:00:16 +0200
From: Tejun Heo <tj@kernel.org>
To: Anton Blanchard <anton@samba.org>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, eric.dumazet@gmail.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Message-ID: <20110826090016.GD2632@htj.dyndns.org>
References: <20110826072622.406d3395@kryten>
 <20110826072927.5b4781f9@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826072927.5b4781f9@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 07:29:27AM +1000, Anton Blanchard wrote:
> 
> When testing on a 1024 thread ppc64 box I noticed a large amount of
> CPU time in ext4 code.
> 
> ext4_has_free_blocks has a fast path to avoid summing every free and
> dirty block per cpu counter, but only if the global count shows more
> free blocks than the maximum amount that could be stored in all the
> per cpu counters.
> 
> Since percpu_counter_batch scales with num_online_cpus() and the maximum
> amount in all per cpu counters is percpu_counter_batch * num_online_cpus(),
> this breakpoint grows at O(n^2).
> 
> This issue will also hit with users of percpu_counter_compare which
> does a similar thing for one percpu counter.
> 
> I chose to cap percpu_counter_batch at 1024 as a conservative first
> step, but we may want to reduce it further based on further benchmarking.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Yeah, capping the upper bound seems reasonable but can you please add
some comment explaining why the upper bound is necessary there?

Thank you.

-- 
tejun
