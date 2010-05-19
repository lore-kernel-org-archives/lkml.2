Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0ESJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:27:16 -0400
Received: from mga05.intel.com ([192.55.52.89]:12298 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756244Ab0ESJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,262,1272870000"; 
   d="scan'208";a="799814943"
Message-ID: <4BF3AEEC.1070000@linux.intel.com>
Date: Wed, 19 May 2010 11:27:08 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: tim <tim.c.chen@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tmpfs: Improve tmpfs scalability
References: <1274225666.31973.8949.camel@mudge.jf.intel.com>
In-Reply-To: <1274225666.31973.8949.camel@mudge.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

, tim wrote:
>
> We created a token jar library implementing
> per cpu cache of tokens to avoid lock contentions whenever
> we retrieve or return a token to a token jar.  Using this library
> with tmpfs, we find Aim7 fserver throughput improved 270%
> on a 4 socket, 32 cores NHM-EX system.
>
> In current implementation of tmpfs, whenever we
> get a new page, stat_lock in shmem_sb_info needs to be acquired.
> This causes a lot of lock contentions when multiple
> threads are using tmpfs simultaneously, which makes
> system with large number of cpus scale poorly.
> Almost 75% of cpu time was spent contending on
> stat_lock when we ran Aim7 fserver load with 128 threads
> on a 4 socket, 32 cores NHM-EX system.
>
> The first patch in the series implements the quick token jar.
> The second patch update the shmem code of tmpfs to use this
> library to improve tmpfs performance.

I reviewed both patches and they look good to me.
Especially the token jar library should be useful in other places
too.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
