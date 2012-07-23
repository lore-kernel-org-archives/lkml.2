Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2GWAdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:33:49 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43329 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2GWAds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:33:48 -0400
Message-ID: <500C9BE4.70108@linux.vnet.ibm.com>
Date: Sun, 22 Jul 2012 19:33:40 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] zsmalloc: add page table mapping method
References: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com> <1342630556-28686-3-git-send-email-sjenning@linux.vnet.ibm.com> <20120723002655.GC4037@bbox>
In-Reply-To: <20120723002655.GC4037@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072300-6148-0000-0000-000007E3C0CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 07:26 PM, Minchan Kim wrote:
> On Wed, Jul 18, 2012 at 11:55:56AM -0500, Seth Jennings wrote:
>> This patchset provides page mapping via the page table.
>> On some archs, most notably ARM, this method has been
>> demonstrated to be faster than copying.
>>
>> The logic controlling the method selection (copy vs page table)
>> is controlled by the definition of USE_PGTABLE_MAPPING which
>> is/can be defined for any arch that performs better with page
>> table mapping.
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>> ---
>>  drivers/staging/zsmalloc/zsmalloc-main.c |  182 ++++++++++++++++++++++--------
>>  drivers/staging/zsmalloc/zsmalloc_int.h  |    6 -
>>  2 files changed, 134 insertions(+), 54 deletions(-)
>>
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index b86133f..defe350 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -89,6 +89,30 @@
>>  #define CLASS_IDX_MASK	((1 << CLASS_IDX_BITS) - 1)
>>  #define FULLNESS_MASK	((1 << FULLNESS_BITS) - 1)
>>  
>> +/*
>> + * By default, zsmalloc uses a copy-based object mapping method to access
>> + * allocations that span two pages. However, if a particular architecture
>> + * 1) Implements local_flush_tlb_kernel_range() and 2) Performs VM mapping
>> + * faster than copying, then it should be added here so that
> 
> How about adding your benchmark url?
> 
>> + * USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use page table
>> + * mapping rather than copying
>> + * for object mapping.
> 
> unnecessary new line.

Since these aren't functional issues with the code, if I
_promise_ to send a follow-up patch to address these, can I
get your Ack?

--
Seth

