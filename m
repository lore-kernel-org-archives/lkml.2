Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1DUGip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:38:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:15425 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1DUGio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:38:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,250,1301900400"; 
   d="scan'208";a="631902765"
Message-ID: <4DAFD0F2.5080708@intel.com>
Date: Thu, 21 Apr 2011 14:38:42 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: "Wu, Fengguang" <fengguang.wu@intel.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/4] HWPoison: add memory_failure_queue()
References: <1303177419-22466-1-git-send-email-ying.huang@intel.com> <20110420090305.GB3761@localhost>
In-Reply-To: <20110420090305.GB3761@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Fengguang,

On 04/20/2011 05:03 PM, Wu, Fengguang wrote:
>> +	if (kfifo_put(&mf_cpu->fifo, &entry))
>> +		schedule_work_on(smp_processor_id(), &mf_cpu->work);
>> +	else
>> +		pr_err("Memory failure: buffer overflow when recovering memory failure at 0x%#lx\n",
>> +		       pfn);
> 
> nitpick: "buffer overflow when recording memory failure at PFN ..."?

Yes, in fact we are not recovering now.  Or "s/recording/queuing/"?

Best Regards,
Huang Ying
