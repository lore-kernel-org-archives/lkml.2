Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2KLOu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab2KLOu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:50:56 -0500
Message-ID: <50A10CBA.7000200@redhat.com>
Date: Mon, 12 Nov 2012 15:50:34 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, Jiri Slaby <jslaby@suse.cz>,
        Valdis.Kletnieks@vt.edu, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: kswapd0: excessive CPU usage
References: <20121015110937.GE29125@suse.de> <5093A3F4.8090108@redhat.com> <5093A631.5020209@suse.cz> <509422C3.1000803@suse.cz> <509C84ED.8090605@linux.vnet.ibm.com> <509CB9D1.6060704@redhat.com> <20121109090635.GG8218@suse.de> <509F6C2A.9060502@redhat.com> <20121112121956.GT8218@suse.de> <50A0F5F0.6090400@redhat.com> <20121112133139.GU8218@suse.de>
In-Reply-To: <20121112133139.GU8218@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 12.11.2012 14:31, Mel Gorman napsal(a):
> On Mon, Nov 12, 2012 at 02:13:20PM +0100, Zdenek Kabelac wrote:
>> Dne 12.11.2012 13:19, Mel Gorman napsal(a):
>>> On Sun, Nov 11, 2012 at 10:13:14AM +0100, Zdenek Kabelac wrote:
>>>> Hmm,  so it's just took longer to hit the problem and observe kswapd0
>>>> spinning on my CPU again - it's not as endless like before - but
>>>> still it easily eats minutes - it helps to  turn off  Firefox or TB
>>>> (memory hungry apps) so kswapd0 stops soon - and restart those apps
>>>> again.
>>>> (And I still have like >1GB of cached memory)
>>>>
>>>
>>> I posted a "safe" patch that I believe explains why you are seeing what
>>> you are seeing. It does mean that there will still be some stalls due to
>>> THP because kswapd is not helping and it's avoiding the problem rather
>>> than trying to deal with it.
>>>
>>> Hence, I'm also going to post this patch even though I have not tested
>>> it myself. If you find it fixes the problem then it would be a
>>> preferable patch to the revert. It still is the case that the
>>> balance_pgdat() logic is in sort need of a rethink as it's pretty
>>> twisted right now.
>>>
>>
>>
>> Should I apply them all together for 3.7-rc5 ?
>>
>> 1) https://lkml.org/lkml/2012/11/5/308
>> 2) https://lkml.org/lkml/2012/11/12/113
>> 3) https://lkml.org/lkml/2012/11/12/151
>>
>
> Not all together. Test either 1+2 or 1+3. 1+2 is the safer choice but
> does nothing about THP stalls. 1+3 is a riskier version but depends on
> me being correct on what the root cause of the problem you see it.
>
> If both 1+2 and 1+3 work for you, I'd choose 1+3 for merging. If you only
> have the time to test one combination then it would be preferred that you
> test the safe option of 1+2.
>
>

I'll go with 1+2 for couple days - the issue is  - I've no idea how it gets
suddenly triggered - it seemed to be running fine for 2-3 days even with
just 1) - but then kswapd0 started to occupy CPU for minutes.
Looks like some intensive workload on firefox (flash) may lead to that.

Anyway it's hard to tell quickly if it helped.

Zdenek

