Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab2JSO1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:27:19 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57319 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030291Ab2JSO1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:27:15 -0400
Message-ID: <5081630B.2000004@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2012 19:56:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] mm: Simplify for_each_populated_zone()
References: <20121019105546.9704.93446.stgit@srivatsabhat.in.ibm.com> <20121019135454.GJ31863@cmpxchg.org>
In-Reply-To: <20121019135454.GJ31863@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12101914-5490-0000-0000-000002508E2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 07:24 PM, Johannes Weiner wrote:
> On Fri, Oct 19, 2012 at 04:25:47PM +0530, Srivatsa S. Bhat wrote:
>> Move the check for populated_zone() to the control statement of the
>> 'for' loop and get rid of the odd looking if/else block.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  include/linux/mmzone.h |    7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 50aaca8..5bdf02e 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -913,11 +913,8 @@ extern struct zone *next_zone(struct zone *zone);
>>  
>>  #define for_each_populated_zone(zone)		        \
>>  	for (zone = (first_online_pgdat())->node_zones; \
>> -	     zone;					\
>> -	     zone = next_zone(zone))			\
>> -		if (!populated_zone(zone))		\
>> -			; /* do nothing */		\
>> -		else
>> +	     zone && populated_zone(zone);		\
>> +	     zone = next_zone(zone))
> 
> I don't think we want to /abort/ the loop when encountering an
> unpopulated zone.
> 

Oops! I totally missed that.. thanks for catching it! Please ignore
the patch.

Regards,
Srivatsa S. Bhat

