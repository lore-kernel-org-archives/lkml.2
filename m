Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1FKRWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 13:22:20 -0400
Received: from mta11.charter.net ([216.33.127.80]:45936 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1FKRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 13:22:16 -0400
X-Greylist: delayed 6543 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jun 2011 13:22:16 EDT
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=p9YancsnzTcA:10 a=bwGQv-0rnx0A:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=IifoD2hXYIodyOrEDE4A:9 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DF3A447.3050505@cuw.edu>
Date: Sat, 11 Jun 2011 12:22:15 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Nicolas Palix <Nicolas.Palix@inria.fr>, rdunlap@xenotime.net,
        Gilles.Muller@lip6.fr, cocci@diku.dk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] coccicheck: add M= option to control which dir is
 processed
References: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu> <1307503774-30370-2-git-send-email-Gregory.Dietsche@cuw.edu> <4DEFC6DA.9050809@cuw.edu> <BANLkTi=gZzsZcSKUd3x50PbPwKC-Vnj24Q@mail.gmail.com> <4DF38AB8.4080004@cuw.edu> <Pine.LNX.4.64.1106111740130.13465@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1106111740130.13465@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/11/2011 10:40 AM, Julia Lawall wrote:
> On Sat, 11 Jun 2011, Greg Dietsche wrote:
>
>    
>> On 06/08/2011 02:10 PM, Nicolas Palix wrote:
>>      
>>> I am not familiar with out-of-tree development but I guess that in
>>> that case we should
>>> also add a "-I $KBUILD_EXTMOD/include" ?
>>>
>>>
>>>        
>> I decided to skip doing this in V2 of the patch. I did a very quick test and
>> cocci didn't seem to like two -I flags on one command line.
>>      
> What was the problem and what version of coccinelle do you have?  To my
> recollection, the ability to have multiple -I options was added sometime
> not so long ago.
>
>    
Hmm... my 'quick' test must have been bad. I just tested again with 
0.2.3 (debian squeeze) and 1.0.0-rc3 and both seem to work just with 
multiple -I options. As I recall, originally, the script just exited 
with a code of 1 in my original test...

so the updated line really should read:
OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I 
$KBUILD_EXTMOD/include"

I'll send an updated patch in a day or two. I've got some other stuff to 
do today. Also, I noticed another bug that I'll need to fix too. The 
lines in my patch that read:
             echo 'M= is only supported for Coccinelle >= 0.2.3'
             exit 1
are flat out wrong... :(

Greg

> julia
>
>    
>>> The use of -I by Coccinelle depends on the other options (like
>>> -include_headers or -all_includes).
>>> Such options are retrieved from the comments in the cocci files.
>>> So the need for -I depends on the semantic patch you consider. I think
>>> it is thus better
>>> to be "exhaustive" in that case.
>>>
>>> Julia, is there any performance problem in doing so ?
>>>
>>>        
>> Greg
>>      
