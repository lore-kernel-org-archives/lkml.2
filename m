Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2GIHWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:22:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2GIHWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:22:50 -0400
Message-ID: <4FFA86C5.7090601@gmail.com>
Date: Mon, 09 Jul 2012 17:22:45 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Antw: Re: /sys and access(2): Correctly implemented?
References: <4FF6A17B020000A10000A5E8@gwsmtp1.uni-regensburg.de> <4FFA16B6.9050009@gmail.com> <4FFA950B020000A10000A68F@gwsmtp1.uni-regensburg.de>
In-Reply-To: <4FFA950B020000A10000A68F@gwsmtp1.uni-regensburg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/12 16:23, Ulrich Windl wrote:
>>>> Ryan Mallon <rmallon@gmail.com> schrieb am 09.07.2012 um 01:24 in Nachricht
> <4FFA16B6.9050009@gmail.com>:
>> On 06/07/12 16:27, Ulrich Windl wrote:
>>> Hi!
>>>
>>> Recently I found a problem with the command (kernel 3.0.34-0.7-default from 
>> SLES 11 SP2, run as root):
>>> test -r "$file" && cat "$file"
>>> emitting "Permission denied"
>>>
>>> Investigating, I found that "test" actually uses "access()" to check for 
>> permissions. Unfortunately there are some files in /sys that have "write-only" 
>> permission bits set (e.g. /sys/devices/system/cpu/probe).
>>>
>>> ~ # ll /sys/devices/system/cpu/probe
>>> --w------- 1 root root 4096 Jun 29 12:43 /sys/devices/system/cpu/probe
>>> ~ # F=/sys/devices/system/cpu/probe
>>> ~ # test "$F" && cat "$F"
>>> cat: /sys/devices/system/cpu/probe: Permission denied
>>
>> Looks like you have a typo here, I think you wanted "test -r $F", not
>> "test $F", the latter will just evaluate "$F" as an expression which
>> will be true, and so you get the permission denied error running cat.
> 
> Hi!
> 
> You are right: It's a typo, but only in the message; the actual test was done correctly, and the outcome is quite the same.
> 
>>
>> Using "test -r $F" on a write-only sysfs file correctly returns false on
>> my machine (Ubuntu 10.04.4 LTS/2.6.32-41-generic).
> 
> Not here, unfortunately:

Oops, I missed the bit about you running as root. I get the same results
running as root on my machine as you, both for sysfs and regular files.

It appears that access(2) as the super-user is might be implementation
defined, see:

  http://pubs.opengroup.org/onlinepubs/000095399/functions/access.html
  http://lists.gnu.org/archive/html/bug-bash/2010-07/msg00071.html

However, I can't find any concrete information on it for Linux, and the
manpage doesn't mention anything other the the X_OK bit.

~Ryan
