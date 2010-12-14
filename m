Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0LNWmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:42:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164Ab0LNWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:42:04 -0500
Date: Tue, 14 Dec 2010 17:41:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101214224135.GB19693@redhat.com>
References: <20101203175401.GE28603@hmsreliant.think-freely.org>
 <20101207105053.GA2803@redhat.com>
 <4CFE89FE.1090901@kernel.org>
 <20101208141942.GA2335@redhat.com>
 <4D00823A.9050808@kernel.org>
 <20101209124117.GA6032@redhat.com>
 <4D01377B.5070809@kernel.org>
 <20101213100848.GA2237@redhat.com>
 <4D0663F0.2060103@kernel.org>
 <4D06783C.6040009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D06783C.6040009@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 11:47:08AM -0800, H. Peter Anvin wrote:
> On 12/13/2010 10:20 AM, Yinghai Lu wrote:
> > 
> > it seems 32bit kdump need crashkernel much low than we expect...
> > 
> > Maybe we have to find_in_range_low() to make 32bit kdump happy.
> > 
> 
> Not this garbage again... sigh.  Once again, I will want to know what
> the actual constraint is... not just "oh, this seems to work on this one
> system."
> 
> I realize that the kdump interfaces are probably beyond saving -- we
> have had this discussion enough times -- but I'm not happy about it and
> I will really want to know what the heck the real issue is.

Same here Yinghai. We need to debug that what is that upper limit for
loading x86 32bit kernel and if we know/understand that, we can fail
the loading of kdump kernel citing the appropriate reason. Last time
our understanding was that as long as we allocate memory below 896MB
things should be fine.

Stanislaw, how much memory you are reserving at what address with -rc4
kernel? Can you please look at  /proc/iomem? And try to reserve same
amount of memory at roughly same address at 2.6.36 kernel, and see if
kdump works.

So how I used to debug problems in kdump path. 

- Try earlyprintk for second kernel.
- Try --debug, --console-serial options with kexec while loading second
  kernel. Important thing to know here is control reached to purgatory
  or not.
- If that gives me nothing then it boils down to putting some outb()
  statements in first kernel and second kernel boot path to know where
  things went wrong.

  Because the issue was resolved by reserving memory in low memory
  area, it sounds like second kernel failed to boot early. So early
  printk might help otherwise outb() and serial console is the friend.

Thanks
Vivek
