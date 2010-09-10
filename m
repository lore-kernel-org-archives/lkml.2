Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0IJKTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:19:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:50555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0IJKTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:19:37 -0400
Message-ID: <4C8A0628.9010601@kernel.org>
Date: Fri, 10 Sep 2010 12:19:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: shijie8@gmail.com, cl@linux-foundation.org, mingo@elte.hu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Failure in pcpu_extend_area_map()
References: <20100909214058.GA9650@sgi.com>
In-Reply-To: <20100909214058.GA9650@sgi.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 10:19:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/09/2010 11:40 PM, Jack Steiner wrote:
> We have started to see failures in the percpu allocator in recent
> linux-next kernels. Failures seem to occur immediately
> after pcpu_chunk_relocate() is called to relocate a chunk from slot
> 10 in pcpu_slot[] to slot 0.
> 
> It appears that the list_for_each_entry() in pcpu_alloc() fails
> after pcpu_chunk_relocate() does the list_move().
> 
> 
> Call tree is:
> 	pcpu_alloc -> pcpu_alloc_area -> pcpu_chunk_relocate 	(at end of function - /* fully scanned */)
> 
> 
> Adding the following patch fixes the problem but I suspect this is not the proper
> fix. Has anyone else seen this this failure?

I've been trying to reproduce it but without success yet.  Can you
please attach .config you're using?  How reproducible is the problem?
If it's reliably reproducible, can you please check whether the
offending chunk (which gets moved to slot 0 before crash) equals
pcpu_first_chunk?

Thanks.

-- 
tejun
