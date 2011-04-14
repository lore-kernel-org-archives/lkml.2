Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1DNB3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 21:29:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:7930 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab1DNB3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 21:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,208,1301900400"; 
   d="scan'208";a="418847786"
Message-ID: <4DA64DE9.9050707@intel.com>
Date: Thu, 14 Apr 2011 09:29:13 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3 3/4] lib, Make gen_pool memory allocator lockless
References: <1302684835-14133-1-git-send-email-ying.huang@intel.com> <1302684835-14133-4-git-send-email-ying.huang@intel.com> <20110413210757.GA11683@Krystal>
In-Reply-To: <20110413210757.GA11683@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 05:07 AM, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
> [...]
>> + * rcu_read_lock and rcu_read_unlock is not used int gen_pool_alloc,
>> + * gen_pool_free, gen_pool_avail and gen_pool_size etc, because chunks
>> + * are only added into pool, not deleted from pool unless the pool
>> + * itself is destroyed.  If chunk will be deleted from pool,
>> + * rcu_read_lock and rcu_read_unlock should be uses in these
>> + * functions.
> 
> So how do you protect between pool destruction and adding chunks into
> the pool ?

Because the pool itself will be freed when destruction, we need some
mechanism outside of pool.  For example, if gen_pool_add() is called via
device file IOCTL, we must un-register the device file first, and
destroy the pool after the last reference to device has gone.

Best Regards,
Huang Ying
