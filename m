Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0IPTgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:36:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28494 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0IPTgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:36:12 -0400
Message-ID: <4C92719E.5070103@oracle.com>
Date: Thu, 16 Sep 2010 12:35:58 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Wright <john.wright@hp.com>
Subject: Re: 2.6.32.y stable kernel regression with taskset
References: <4C9114A6.6040500@oracle.com> <1284608712.7403.10.camel@marge.simson.net> <20100916144216.GA4794@suse.de>
In-Reply-To: <20100916144216.GA4794@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 07:42 AM, Greg KH wrote:
> On Thu, Sep 16, 2010 at 05:45:12AM +0200, Mike Galbraith wrote:
>> On Wed, 2010-09-15 at 11:47 -0700, Yinghai Lu wrote:
>>> found problem with cpuscaling test.
>>>
>>> Under 2.6.32.21   Userspace gov  
>>> min freq load test time is nearly the same as max freq load test time around  ~16 seconds
>>>
>>> under 2.6.18-194
>>> min freq load test time is ~40 seconds
>>> max freq load test time	  is ~ 17 seconds
>>>
>>> the test is 
>>> 1. set governor for one cpu to userspace
>>> 2. set freq to min for that cpu
>>> 3. using taskset to put load test only on that cpu, and get the time for load test.
>>>
>>> so that mean taskset did not put load test on cpu that we want. and other cpu still have ondemand governor and load test get done much faster
>>>
>>> git bisect report:
>>>
>>> c6fc81afa2d7ef2f775e48672693d8a0a8a7325d is the first bad commit
>>> commit c6fc81afa2d7ef2f775e48672693d8a0a8a7325d
>>> Author: John Wright <john.wright@hp.com>
>>> Date:   Tue Apr 13 16:55:37 2010 -0600
>>>
>>>     sched: Fix a race between ttwu() and migrate_task()
>>
>> Known issue.  There's a sched series for 32-stable in the pipeline.
> 
> Yes, sorry, I'm working my way through to them, hope to have them
> finished and applied soon.
> 

why not just revert that patch?

wonder if SLES11SP1 or RHEL 6 have this patch or not.

Yinghai

