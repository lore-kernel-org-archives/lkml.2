Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab1FKPhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:37:18 -0400
Received: from mta11.charter.net ([216.33.127.80]:56801 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab1FKPhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:37:14 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=p9YancsnzTcA:10 a=N2sXiA72-zoA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=xNjWJ0b5AAAA:8 a=W6GXgZyJ3H9hBgKsB-sA:9
 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DF38BAA.9050406@cuw.edu>
Date: Sat, 11 Jun 2011 10:37:14 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic patch
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu> <Pine.LNX.4.64.1106060651320.7113@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1106060651320.7113@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2011 11:55 PM, Julia Lawall wrote:
> Thanks.  I tried this too, but I wasn't sure about the results.  The
> question is why stop here.  For example, there are IS_ERR calls that one
> could consider as well.  Or ret<  0.  Or why not just:
>
> @@
> expression ret;
> @@
>
> - if (...) return ret;
>    return ret;
>
>    
I've been thinking a bit more about this. Is there a community 
preference towards patches that are highly reliable v.s. ones that find 
things that might not be a problem? I'm leaning towards updating my 
patch to do the above and then later coming back when I have more time 
to fix it up to find only things that are really problems.

Greg
> Although there might be function calls that one doesn't want to touch, so:
>
> @@
> identifier f != IS_ERR;
> expression ret;
> statement S;
> @@
>
> (
> if (<+...f(...)...+>) S
> |
> - if (...) return ret;
>    return ret;
> )
>
> julia
>
>
> On Sun, 5 Jun 2011, Greg Dietsche wrote:
>
>    
>> This semantic patch finds code matching this pattern:
>> 	if(ret)
>> 		return ret;
>> 	return ret;
>>
>> I will be submitting patches shortly against the mainline to cleanup all
>> code matching this pattern.
>>
>> Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
>> ---
>>   scripts/coccinelle/misc/doublereturn.cocci |   20 ++++++++++++++++++++
>>   1 files changed, 20 insertions(+), 0 deletions(-)
>>   create mode 100644 scripts/coccinelle/misc/doublereturn.cocci
>>
>> diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
>> new file mode 100644
>> index 0000000..656a118
>> --- /dev/null
>> +++ b/scripts/coccinelle/misc/doublereturn.cocci
>> @@ -0,0 +1,20 @@
>> +/// Remove unecessary if/return in code that follows this pattern:
>> +///	if(retval)
>> +///		return retval;
>> +///	return retval;
>> +//
>> +// Confidence: High
>> +// Copyright: (C) 2011 Greg Dietsche GPLv2.
>> +// URL: http://www.gregd.org
>> +// Comments:
>> +// Options: -no_includes
>> +
>> +virtual patch
>> +
>> +@@
>> +identifier retval;
>> +@@
>> +-if (retval)
>> +-	return retval;
>> +-return retval;
>> ++return retval;
>> -- 
>> 1.7.2.5
>>
>>
>>      
>    
