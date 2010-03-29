Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0C2MEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:04:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55663 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0C2MEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:04:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BB09736.5010009@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 21:04:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: scheduler bug: process running since 5124095h
References: <4BADD408.8080609@gmail.com>  <4BAF1802.8070002@gmail.com> <1269859960.6844.4.camel@marge.simson.net>
In-Reply-To: <1269859960.6844.4.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/03/29 19:52), Mike Galbraith wrote:
> On Sun, 2010-03-28 at 11:49 +0300, Török Edwin wrote:
>> On 03/27/2010 11:46 AM, Török Edwin wrote:
>>> Hi Ingo, Peter,
>>>
>>> top has just shown me this:
>>> PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>>
>>>                                                                  6524
>>> edwin     20   0  228m  10m 8116 R    2  0.3  5124095h gkrellm
>>>
>>> Now obviously that process is not running since 5124095h!
>>> It looks like some overflow to me, the time in nanoseconds would be
>>> approx 0xFFFFFE1D2D476000, which is approx. minus 34 minutes.
>>> Thats about consistent with the uptime, but I don't know why it became
>>> negative:
>>>  11:45:48 up 42 min,  9 users,  load average: 0.56, 0.25, 0.19
>>>
>>> I've attached the cfs-debug-info.sh output.
>>>
>>> This happens when using Linux 2.6.33 (actually glisse's drm-radeon tree
>>> which is based on 2.6.33), its the first time I noticed this.
>>>
>>> I don't know what caused it, the last things I did was:
>>
>> I have a simple way to reproduce this:
>> 1. Boot the system, run top, confirm everything is normal
>> 2. Run latencytop, and quit (I used version 0.5)
>> 3. Run top, see 5124095h in the TIME column
> 
> Indeed, and I don't even have CONFIG_LATENCYTOP set.  It bisected to...
> 
> 761b1d26df542fd5eb348837351e4d2f3bc7bffe is the first bad commit
> commit 761b1d26df542fd5eb348837351e4d2f3bc7bffe
> Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Date:   Thu Nov 12 13:33:45 2009 +0900

Wow, it's easy to reproduce. I'll check it later... 


Thanks,
H.Seto

