Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2HCVNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:13:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52046 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2HCVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:13:54 -0400
Message-ID: <501C3F2B.7080004@gmail.com>
Date: Fri, 03 Aug 2012 23:14:19 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 7/7] net,9p: use new hashtable implementation
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>  <1344003788-1417-8-git-send-email-levinsasha928@gmail.com> <1344016851.9299.1415.camel@edumazet-glaptop>
In-Reply-To: <1344016851.9299.1415.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 08:00 PM, Eric Dumazet wrote:
> On Fri, 2012-08-03 at 16:23 +0200, Sasha Levin wrote:
>>  	/* initialize hash table */
>> -	for (bucket = 0; bucket < ERRHASHSZ; bucket++)
>> -		INIT_HLIST_HEAD(&hash_errmap[bucket]);
>> +	hash_init(&hash_errmap, ERRHASHSZ);
> 
> Why is hash_init() even needed ?
> 
> If hash is "DEFINE_STATIC_HASHTABLE(...)", its already ready for use !

Indeed it is.

I've removed it, and then decided to put it back since the definition of the hashtable isn't fully cooked yet, and I didn't want to miss this initialization point if it turn out we need to initialize that hashtable afterall.

I will remove it once the hashtable definitions are clear.

The rest of the review comments will be addressed.

Thanks!
