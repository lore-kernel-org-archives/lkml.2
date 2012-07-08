Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2GHXYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:24:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2GHXYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:24:43 -0400
Message-ID: <4FFA16B6.9050009@gmail.com>
Date: Mon, 09 Jul 2012 09:24:38 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: /sys and access(2): Correctly implemented?
References: <4FF6A17B020000A10000A5E8@gwsmtp1.uni-regensburg.de>
In-Reply-To: <4FF6A17B020000A10000A5E8@gwsmtp1.uni-regensburg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/12 16:27, Ulrich Windl wrote:
> Hi!
> 
> Recently I found a problem with the command (kernel 3.0.34-0.7-default from SLES 11 SP2, run as root):
> test -r "$file" && cat "$file"
> emitting "Permission denied"
> 
> Investigating, I found that "test" actually uses "access()" to check for permissions. Unfortunately there are some files in /sys that have "write-only" permission bits set (e.g. /sys/devices/system/cpu/probe).
> 
> ~ # ll /sys/devices/system/cpu/probe
> --w------- 1 root root 4096 Jun 29 12:43 /sys/devices/system/cpu/probe
> ~ # F=/sys/devices/system/cpu/probe
> ~ # test "$F" && cat "$F"
> cat: /sys/devices/system/cpu/probe: Permission denied

Looks like you have a typo here, I think you wanted "test -r $F", not
"test $F", the latter will just evaluate "$F" as an expression which
will be true, and so you get the permission denied error running cat.

Using "test -r $F" on a write-only sysfs file correctly returns false on
my machine (Ubuntu 10.04.4 LTS/2.6.32-41-generic).

~Ryan
