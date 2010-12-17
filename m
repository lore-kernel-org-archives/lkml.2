Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0LQUBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:01:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab0LQUBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:01:53 -0500
Date: Fri, 17 Dec 2010 15:01:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101217200139.GF14502@redhat.com>
References: <4D0AD976.3020504@zytor.com>
 <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org>
 <20101217170146.GC9568@redhat.com>
 <4D0BA45A.7020402@zytor.com>
 <20101217180242.GB12425@redhat.com>
 <4D0BAA24.3080801@kernel.org>
 <4D0BBC55.4010207@zytor.com>
 <4D0BBE00.3010602@kernel.org>
 <20101217195035.GE14502@redhat.com>
 <4D0BBF6B.4060105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0BBF6B.4060105@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:52:11AM -0800, Yinghai Lu wrote:
> On 12/17/2010 11:50 AM, Vivek Goyal wrote:
> > On Fri, Dec 17, 2010 at 11:46:08AM -0800, Yinghai Lu wrote:
> >> On 12/17/2010 11:39 AM, H. Peter Anvin wrote:
> >>> On 12/17/2010 10:21 AM, Yinghai Lu wrote:
> >>>>>>
> >>>>>> Do we have actual testing for how high the 64-bit kernel will load?
> >>>>>
> >>>>> I will do some experiments on my box today and let you know.
> >>>>
> >>>> if bzImage is used, it is 896M.
> >>>>
> >>>
> >>> Why?  896 MiB is a 32-bit kernel limitation which doesn't have anything
> >>> to do with the bzImage format.
> >>>
> >>> So unless there is something going on here, I suspect you're just plain
> >>> flat wrong.
> >>
> >> kexec-tools have some checking when it loads bzImage.
> >>
> > 
> > Yinghai,
> > 
> > I think x86_64 might have just inherited the settings of 32bit without
> > giving it too much of thought. At that point of time nobody bothered
> > to load the kernel from high addresses. So these might be artificial
> > limits.
> 
> good point.  will check that.

Yinghai,

On x86_64, I am not seeing "Crash kernel" entry in /proc/iomem.

I see following in dmesg.

"[    0.000000] Reserving 128MB of memory at 64MB for crashkernel (System
RAM: 5120MB)"

Following is my /proc/iomem.

# cat /proc/iomem 
00000100-0000ffff : reserved
00010000-00096fff : System RAM
00097000-0009ffff : reserved
000c0000-000e7fff : pnp 00:0f
000e8000-000fffff : reserved
00100000-bffc283f : System RAM
  01000000-015d1378 : Kernel code
  015d1379-01aee00f : Kernel data
  01bc8000-024b4c4f : Kernel bss
bffc2840-bfffffff : reserved

So there is RAM available at the requested address still no entry for
"Crash Kernel". This is both with 2.6.36 as well as 37-rc6 kernel. I am 
wondering if insert_resource() is failing here?

Thanks
Vivek
