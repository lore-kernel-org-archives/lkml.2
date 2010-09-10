Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0IJKHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:07:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50152 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0IJKHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:07:53 -0400
Message-ID: <4C8A0375.4080503@kernel.dk>
Date: Fri, 10 Sep 2010 12:07:49 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Brian King <brking@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Range check cpu in blk_cpu_to_group
References: <201009091741.o89HfPfM011522@d03av02.boulder.ibm.com>
In-Reply-To: <201009091741.o89HfPfM011522@d03av02.boulder.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2010 07:41 PM, Brian King wrote:
> While testing CPU DLPAR, the following problem was discovered.
> We were DLPAR removing the first CPU, which in this case was
> logical CPUs 0-3. CPUs 0-2 were already marked offline and
> we were in the process of offlining CPU 3. After marking
> the CPU inactive and offline in cpu_disable, but before the
> cpu was completely idle (cpu_die), we ended up in __make_request
> on CPU 3. There we looked at the topology map to see which CPU
> to complete the I/O on and found no CPUs in the cpu_sibling_map.
> This resulted in the block layer setting the completion cpu
> to be NR_CPUS, which then caused an oops when we tried to
> complete the I/O.
> 
> Fix this by sanity checking the value we return from blk_cpu_to_group
> to be a valid cpu value.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Thanks Brian, applied.

-- 
Jens Axboe

