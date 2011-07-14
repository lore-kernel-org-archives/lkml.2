Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1GNCOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 22:14:36 -0400
Received: from mta31.charter.net ([216.33.127.82]:49161 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1GNCOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 22:14:35 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=_PlU6wiDepAA:10 a=0qEacxHv6EQA:10 a=IkcTkHD0fZMA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=mDV3o1hIAAAA:8 a=Wa7BnzGuu0YlRcGE0VcA:9
 a=QEXdDO2ut3YA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E1E510A.6010005@cuw.edu>
Date: Wed, 13 Jul 2011 21:14:34 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 3/3] coccicheck: add parallel execution
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>	 <1310520405-1558-4-git-send-email-Gregory.Dietsche@cuw.edu> <1310524935.32558.8.camel@Joe-Laptop>
In-Reply-To: <1310524935.32558.8.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 09:42 PM, Joe Perches wrote:
> On Tue, 2011-07-12 at 20:26 -0500, Greg Dietsche wrote:
>    
>> For example to process 6 SmPL patches at the same time:
>> 	make coccicheck PARALLEL=6
>> Results are held in /tmp until the scripts finish. By doing this the
>> script is able to collate the results from each SmPL patch instead of
>> interleaving them in the output.
>>      
> You might try adding support for gnu parallel instead.
> http://www.gnu.org/software/parallel/
>
>    
That is a very interesting and useful tool :) I'd never heard of it 
before. The man page scares me a little bit - lots of options are marked 
as "alpha testing," but the ones i tried seemed to work fine. Anyway, 
without any modifications to Coccinelle, it is possible to do this:

ls scripts/coccinelle/*/*.cocci | parallel -j+0 make coccicheck COCCI={} 
MODE=patch

it seems to behave mostly like my patch, but doesn't cleanup quite as 
well if you decide to kill it with ctrl-c (it leaves instances of spatch 
running). On the upside, it is up to 3 seconds faster than my patch 
(because my patch waits 3 seconds before checking on the number of jobs 
that are running).

Greg
