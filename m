Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224Ab2GKUuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:50:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44908 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2GKUuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:50:10 -0400
Message-ID: <4FFDE69C.8080205@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 15:48:28 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: konrad@darnok.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] zsmalloc improvements
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120704204325.GB2924@localhost.localdomain> <4FF6FF1F.5090701@linux.vnet.ibm.com>	<4FFAE37F.70403@linux.vnet.ibm.com> <CAPbh3rtXVf_GPKZ2dA2nWaj=h6aYztntQ-oFD5Pg0j65BbOvmA@mail.gmail.com>
In-Reply-To: <CAPbh3rtXVf_GPKZ2dA2nWaj=h6aYztntQ-oFD5Pg0j65BbOvmA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071120-7408-0000-0000-000006AF07BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:42 PM, Konrad Rzeszutek Wilk wrote:
>>>> Which architecture was this under? It sounds x86-ish? Is this on
>>>> Westmere and more modern machines? What about Core2 architecture?
>>>>
>>>> Oh how did it work on AMD Phenom boxes?
>>>
>>> I don't have a Phenom box but I have an Athlon X2 I can try out.
>>> I'll get this information next Monday.
>>
>> Actually, I'm running some production stuff on that box, so
>> I rather not put testing stuff on it.  Is there any
>> particular reason that you wanted this information? Do you
>> have a reason to believe that mapping will be faster than
>> copy for AMD procs?
> 
> Sorry for the late response. Working on some ugly bug that is taking
> more time than anticipated.
> My thoughts were that these findings are based on the hardware memory
> prefetcher. The Intel
> machines - especially starting with Nehelem have some pretty
> impressive prefetcher where
> even doing in a linked list 'prefetch' on the next node is not beneficial.
> 
> Perhaps the way to leverage this is to use different modes depending
> on the bulk of data?
> When there is a huge amount use the old method, but for small use copy
> (as it would
> in theory stay in the cache longer).

Not sure what you mean by "bulk" or "huge amount" but the
maximum size of mapped object is PAGE_SIZE and the typical
size more around PAGE_SIZE/2. So that is what I'm
considering.  Do you think it makes a difference with copies
that small?

Thanks,
Seth

