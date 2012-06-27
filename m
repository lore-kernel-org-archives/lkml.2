Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab2F0Sfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:35:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43331 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab2F0Sfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:35:45 -0400
Message-ID: <4FEB5267.8000109@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 13:35:19 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9FDD.6030102@kernel.org> <4FEAA4AA.3000406@intel.com> <4FEAA7A1.9020307@kernel.org> <90bcc2c8-bcac-4620-b3c0-6b65f8d9174d@default> <20120627153911.GH17154@phenom.dumpdata.com>
In-Reply-To: <20120627153911.GH17154@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062718-1976-0000-0000-00000E9F758F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 10:39 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 27, 2012 at 08:12:56AM -0700, Dan Magenheimer wrote:
>>> From: Minchan Kim [mailto:minchan@kernel.org]
>>> Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
>>>
>>> Hello,
>>>
>>> On 06/27/2012 03:14 PM, Alex Shi wrote:
>>>
>>>> On 06/27/2012 01:53 PM, Minchan Kim wrote:
>>>>
>>>>> On 06/26/2012 01:14 AM, Seth Jennings wrote:
>>>>>
>>>>>> This patch adds support for a local_tlb_flush_kernel_range()
>>>>>> function for the x86 arch.  This function allows for CPU-local
>>>>>> TLB flushing, potentially using invlpg for single entry flushing,
>>>>>> using an arch independent function name.
>>>>>>
>>>>>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>>>>
>>>>>
>>>>> Anyway, we don't matter INVLPG_BREAK_EVEN_PAGES's optimization point is 8 or something.
>>>>
>>>>
>>>> Different CPU type has different balance point on the invlpg replacing
>>>> flush all. and some CPU never get benefit from invlpg, So, it's better
>>>> to use different value for different CPU, not a fixed
>>>> INVLPG_BREAK_EVEN_PAGES.
>>>
>>> I think it could be another patch as further step and someone who are
>>> very familiar with architecture could do better than.
>>> So I hope it could be merged if it doesn't have real big problem.
>>>
>>> Thanks for the comment, Alex.
>>
>> Just my opinion, but I have to agree with Alex.  Hardcoding
>> behavior that is VERY processor-specific is a bad idea.  TLBs should
>> only be messed with when absolutely necessary, not for the
>> convenience of defending an abstraction that is nice-to-have
>> but, in current OS kernel code, unnecessary.
> 
> At least put a big fat comment in the patch saying:
> "This is based on research done by Alex, where ...

I can do this.

--
Seth

