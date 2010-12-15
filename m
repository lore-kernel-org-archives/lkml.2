Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0LOKkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:40:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab0LOKkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:40:09 -0500
Date: Wed, 15 Dec 2010 11:39:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101215103954.GA2243@redhat.com>
References: <20101207105053.GA2803@redhat.com>
 <4CFE89FE.1090901@kernel.org>
 <20101208141942.GA2335@redhat.com>
 <4D00823A.9050808@kernel.org>
 <20101209124117.GA6032@redhat.com>
 <4D01377B.5070809@kernel.org>
 <20101213100848.GA2237@redhat.com>
 <4D0663F0.2060103@kernel.org>
 <4D06783C.6040009@zytor.com>
 <20101214224135.GB19693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214224135.GB19693@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 05:41:36PM -0500, Vivek Goyal wrote:
> On Mon, Dec 13, 2010 at 11:47:08AM -0800, H. Peter Anvin wrote:
> > On 12/13/2010 10:20 AM, Yinghai Lu wrote:
> > > 
> > > it seems 32bit kdump need crashkernel much low than we expect...
> > > 
> > > Maybe we have to find_in_range_low() to make 32bit kdump happy.
> > > 
> > 
> > Not this garbage again... sigh.  Once again, I will want to know what
> > the actual constraint is... not just "oh, this seems to work on this one
> > system."
> > 
> > I realize that the kdump interfaces are probably beyond saving -- we
> > have had this discussion enough times -- but I'm not happy about it and
> > I will really want to know what the heck the real issue is.
> 
> Same here Yinghai. We need to debug that what is that upper limit for
> loading x86 32bit kernel and if we know/understand that, we can fail
> the loading of kdump kernel citing the appropriate reason. Last time
> our understanding was that as long as we allocate memory below 896MB
> things should be fine.
> 
> Stanislaw, how much memory you are reserving at what address with -rc4
> kernel? 

crashkernel=128M, system has 1G mem.

> Can you please look at  /proc/iomem? And try to reserve same
> amount of memory at roughly same address at 2.6.36 kernel, and see if
> kdump works.
> 
> So how I used to debug problems in kdump path. 
> 
> - Try earlyprintk for second kernel.
> - Try --debug, --console-serial options with kexec while loading second
>   kernel. Important thing to know here is control reached to purgatory
>   or not.
> - If that gives me nothing then it boils down to putting some outb()
>   statements in first kernel and second kernel boot path to know where
>   things went wrong.
> 
>   Because the issue was resolved by reserving memory in low memory
>   area, it sounds like second kernel failed to boot early. So early
>   printk might help otherwise outb() and serial console is the friend.

I could debug this problem, but I do not suffer from free time right
now :-) Would be better someone bootmem/kdump experienced debug this.
I just check other laptop (T500, 2.6.37-rc5, x86_64, RHEL6 user space,
crashkernel=256M, 1.6G mem), kdump does not work there too. So I do
think problem is hard to reproduce.

Stanislaw
