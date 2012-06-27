Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2F0GQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:16:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:40281 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2F0GQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161162629"
Message-ID: <4FEAA4AA.3000406@intel.com>
Date: Wed, 27 Jun 2012 14:14:02 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9FDD.6030102@kernel.org>
In-Reply-To: <4FEA9FDD.6030102@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 01:53 PM, Minchan Kim wrote:

> On 06/26/2012 01:14 AM, Seth Jennings wrote:
> 
>> This patch adds support for a local_tlb_flush_kernel_range()
>> function for the x86 arch.  This function allows for CPU-local
>> TLB flushing, potentially using invlpg for single entry flushing,
>> using an arch independent function name.
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> 
> Anyway, we don't matter INVLPG_BREAK_EVEN_PAGES's optimization point is 8 or something.


Different CPU type has different balance point on the invlpg replacing
flush all. and some CPU never get benefit from invlpg, So, it's better
to use different value for different CPU, not a fixed
INVLPG_BREAK_EVEN_PAGES.
