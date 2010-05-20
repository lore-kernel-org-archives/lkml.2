Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab0ETDwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:52:07 -0400
Received: from mga05.intel.com ([192.55.52.89]:20381 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753553Ab0ETDwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:52:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,268,1272870000"; 
   d="scan'208";a="800122576"
Message-ID: <4BF4B1E1.4030208@linux.intel.com>
Date: Thu, 20 May 2010 11:52:01 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mem-hotplug: update all PGDs for direct mapping
 and vmemmap mapping changes on 64bit.
References: <4BF3D15F.1000604@linux.intel.com> <20100519121202.GB23778@localhost>
In-Reply-To: <20100519121202.GB23778@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
>> @@ -1033,6 +1038,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
>>   		}
>>
>>   	}
>> +	sync_global_pgds((unsigned long)start_page, end);
> 
> Here you removed the tlb flush in the original patch. Is it safe to do so?

Yes, I think so. Before this populate, such vmemmap mapping should be always zero, so it's optional 
to do tlb flush here.

-haicheng
