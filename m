Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2EVSqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:46:07 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35144 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab2EVSqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:46:05 -0400
Message-ID: <4FBBDED6.7030600@linux.vnet.ibm.com>
Date: Tue, 22 May 2012 13:45:42 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] zsmalloc: use unsigned long instead of void *
References: <1337567013-4741-1-git-send-email-minchan@kernel.org> <4FBA4EE2.8050308@linux.vnet.ibm.com> <4FBB97B2.6050408@linux.vnet.ibm.com> <20120522183119.GA24107@phenom.dumpdata.com>
In-Reply-To: <20120522183119.GA24107@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052218-5806-0000-0000-00001576D7A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 01:31 PM, Konrad Rzeszutek Wilk wrote:

> On Tue, May 22, 2012 at 08:42:10AM -0500, Seth Jennings wrote:
>> On 05/21/2012 09:19 AM, Seth Jennings wrote:
>>
>>> On 05/20/2012 09:23 PM, Minchan Kim wrote:
>>>
>>>> We should use unsigned long as handle instead of void * to avoid any
>>>> confusion. Without this, users may just treat zs_malloc return value as
>>>> a pointer and try to deference it.
>>>
>>>
>>> I wouldn't have agreed with you about the need for this change as people
>>> should understand a void * to be the address of some data with unknown
>>> structure.
>>>
>>> However, I recently discussed with Dan regarding his RAMster project
>>> where he assumed that the void * would be an address, and as such,
>>> 4-byte aligned.  So he has masked two bits into the two LSBs of the
>>> handle for RAMster, which doesn't work with zsmalloc since the handle is
>>> not an address.
>>>
>>> So really we do need to convey as explicitly as possible to the user
>>> that the handle is an _opaque_ value about which no assumption can be made.
>>
>>
>> Wasn't really clear here.  All that to say, I think we do need this patch.
> 
> That sounds like an Acked-by ?


Almost. I still need to know what the base is so I can apply the
patchset and at least build it before I add my Ack.

Thanks,
Seth

