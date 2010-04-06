Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0DFG32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:29:28 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63053 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0DFG3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:29:22 -0400
Message-ID: <4BBAD4BC.3000300@monstr.eu>
Date: Tue, 06 Apr 2010 08:29:16 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Fix ftrace_update_ftrace_func panic
References: <1270232979-12113-1-git-send-email-steve@digidescorp.com>	 <4BB9F309.8070807@monstr.eu> <1270490674.3042.174.camel@iscandar.digidescorp.com>
In-Reply-To: <1270490674.3042.174.camel@iscandar.digidescorp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> On Mon, 2010-04-05 at 16:26 +0200, Michal Simek wrote:
>> Steven J. Magnani wrote:
>>> The Microblaze dynamic ftrace code assumes a call ordering that is not met
>>> in all scenarios. Specifically, executing a command similar to:
>>>
>>>   echo 105 > /sys/kernel/debug/tracing/set_ftrace_pid
>>>
>>> before any other tracing-related commands results in a kernel panic:
>>>
>>>   BUG: failure at arch/microblaze/kernel/ftrace.c:198/ftrace_update_ftrace_func()!
>>>
>>> Recoding ftrace_update_ftrace_func() to use &ftrace_caller directly eliminates 
>>> the need to capture its address elsewhere (and thus rely on a particular call 
>>> sequence).
>> I would like to replicate this problem to see that there is. I am not 
>> able to reach this fault
>> Please copy & paste log with your commands.
> 

> # echo 80 > /sys/kernel/debug/tracing/set_ftrace_pid
> BUG: failure at
> arch/microblaze/kernel/ftrace.c:202/ftrace_update_ftrace_func()!
> Kernel panic - not syncing: BUG!

I am able to replicate this fault on both versions.
Added to next branch.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
