Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0KECjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:39:25 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:16502
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab0KECjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:39:22 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dKbb2cK1432N98dNzz1202hzzz2fh2a8h637h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);(null);(null)
Message-ID: <4CD36E41.50505@am.sony.com>
Date: Thu, 4 Nov 2010 19:38:57 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Marcus Meissner <meissner@suse.de>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>, "mort@sgi.com" <mort@sgi.com>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "security@kernel.org" <security@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de>
In-Reply-To: <20101104122906.GH25118@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/10 05:29, Marcus Meissner wrote:
> On Thu, Nov 04, 2010 at 12:46:48PM +0100, Ingo Molnar wrote:
>>
>> * Marcus Meissner <meissner@suse.de> wrote:
>>
>>> Hi,
>>>
>>> Making /proc/kallsyms readable only for root makes it harder for attackers to 
>>> write generic kernel exploits by removing one source of knowledge where things are 
>>> in the kernel.

< snip >

>> So what does a distribution like Suse expect from this change alone? Those have 
>> public packages in rpms which can be downloaded by anyone, so it makes little sense 
>> to hide it - unless _all_ version information is hidden.
> 
> It is the first patch, mostly an acceptance test balloon.
> 
> There are several other files handing information out, but kallsyms has
> it all very nice and ready.
> 
> (timer_list, /proc/*/stat*, sl?binfo )
>  
>> So i'd like to see a _full_ version info sandboxing patch that thinks through all 
>> the angles and restricts uname -r kernel version info as well, and makes dmesg 
>> unaccessible to users - and closes a few other information holes as well that give 
>> away the exact kernel version - _that_ together will make it hard to blindly attack 
>> a very specific kernel version.
> 
> I am personally thinking of a "small steps" philosophy, one step after the other.

< snip >

The idea of trying to hide the kernel version is absurd.  The number of different
places that can provide a precise fingerprint of a kernel version, or a small range of
possible kernel versions is immense.  Closing all of those places makes use and
administration of a system more difficult, and encourages frequent use of su.

Dumb examples of version clues (beyond the obvious simple ones):

$ gcc -v
Target: x86_64-redhat-linux
gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC)

$ rpm -qi gcc
Release     : 10.fc13                       Build Date: Wed Jun 30 02:54:10 2010

$ rpm -qi kernel
Version     : 2.6.33.3                          Vendor: Fedora Project
Release     : 85.fc13                       Build Date: Thu May  6 11:35:36 2010

$ ls -l /lib64
$ ls -l /boot
$ lsmod


-Frank

