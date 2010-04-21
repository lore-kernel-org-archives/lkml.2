Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0DUKmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:42:45 -0400
Received: from mail.agmk.net ([91.192.224.71]:60992 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab0DUKmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:42:44 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: libc-help@sourceware.org, linux-kernel@vger.kernel.org
Subject: Re: mprotect() failed: Cannot allocate memory
References: <201004210105.20942.pluto@agmk.net>
 <1271845010.1776.72.camel@laptop>
Date: Wed, 21 Apr 2010 12:42:40 +0300
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
Message-ID: <op.vbidde06zu3k57@pawels.alatek.krakow.pl>
In-Reply-To: <1271845010.1776.72.camel@laptop>
User-Agent: Opera Mail/10.51 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 21-04-2010 o 13:16:50 Peter Zijlstra <peterz@infradead.org>  
napisał(a):

> On Wed, 2010-04-21 at 01:05 +0200, Paweł Sikora wrote:
>> hi,
>>
>> i'm trying to debug an ugly application with ElectricFence.
>> in fact, on x86-64 box with 8GB ram and 16GB swap i'm getting following  
>> error:
>>
>> "ElectricFence Exiting: mprotect() failed: Cannot allocate memory"
>>
>> the program has been compiled with gcc-4.5, glibc-2.11.1, kernel-2.6.32.
>> did you ever come across such (kernel/glibc) limitations?
>>
>> here's a simple testcase which triggs -ENOMEM in mprotect().
>
> You probably depleted the max map count, see:
>   /proc/sys/vm/max_map_count

yes, that is the clue :)

the limit in /proc/sys/vm/max_map_count was set to 65530.
with `echo 128000 > /proc/sys/vm/max_map_count` the testcase passes.

thanks for hint.
