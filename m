Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0DGALV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab0DGALP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:11:15 -0400
Message-ID: <4BBBCD6F.3050707@redhat.com>
Date: Tue, 06 Apr 2010 20:10:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 03/14] mm: Share the anon_vma ref counts between KSM and
 page migration
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>	<1270224168-14775-4-git-send-email-mel@csn.ul.ie> <20100406170528.ecb30941.akpm@linux-foundation.org>
In-Reply-To: <20100406170528.ecb30941.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 08:05 PM, Andrew Morton wrote:
> On Fri,  2 Apr 2010 17:02:37 +0100
> Mel Gorman<mel@csn.ul.ie>  wrote:

>> +#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
>> +
>> +	/*
>> +	 * The external_refcount is taken by either KSM or page migration
>> +	 * to take a reference to an anon_vma when there is no
>> +	 * guarantee that the vma of page tables will exist for
>> +	 * the duration of the operation. A caller that takes
>> +	 * the reference is responsible for clearing up the
>> +	 * anon_vma if they are the last user on release
>> +	 */
>> +	atomic_t external_refcount;
>>   #endif
>
> hah.

>> +	anonvma_external_refcount_init(anon_vma);
>
> What a mouthful.  Can we do s/external_//g?

For the function, sure.

However, I believe it would be good to keep the variable
inside the anon_vma as "external_refcount", because the
VMAs attached to the anon_vma take a reference by being
on the list (and leave the refcount alone).
