Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0DTUeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:34:13 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:40402 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755188Ab0DTUeL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:34:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 710191.77319.bm@omp110.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0AIb0mSQy13ufwHxZ9I1CYh/DbZPCK9UuMlBQjQX4k1VmNW5VehdrURKPQpZW6nhGQL0eloPYgi9QHr9B2rATsbRM9+bc7WlbwOlOrvE0co5XmxzA9JGiE+86E/MRgD1WeC46Ee4jlHQJkvLb5ee7URZKdBBaVUgzMogWpspG4A=;
Message-ID: <301842.27948.qm@web111913.mail.gq1.yahoo.com>
X-YMail-OSG: lKw0zTwVM1kM8XtylQKCRZeNF5kaFcjzMqspEAKX2w7mFic
 IbmA7IuD6ozl64M5wELMZwrBjNikqHMyKrm9M1Yfk1VFm.uVLRFKKek27RAK
 HTgQE1n5adjirgjUElUhz_KXMlP7jjD3hvvJCj57WAxiDwIsB5iiAv.CxIaV
 FU8KNa0rLeFbxSanEggVItoMEC8tNWyerquqRAua1ZASiMUFFz3BgbJL3Xxq
 BKm6L2Rwf49RzMULtNTSVBKIOYkxwEB3j7lwVA1PyoN7hQc2BDXsKjp8pnhN
 i3w--
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.102.267879
Date: Tue, 20 Apr 2010 13:34:10 -0700 (PDT)
From: Chetan Loke <generationgnu@yahoo.com>
Subject: RE: Memory policy question for NUMA arch....
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rick.sherm@yahoo.com, andi@firstfloor.org, linux-numa@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

--- On Mon, 4/19/10, Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> You should never change the system default once the system
> is up and
> running.
> 

Not sure what I was thinking.Agreed, we should leave the default-policy alone.

> Still not clear on what your requirements are 

Thanks for pointing me to the other post. I might have a similar problem.I've a nehalem box.

1) Drivers supports MSI-X.
  1.1) Drivers at load time allocate a chunk of DMA'able memory.
   
2) Sometime later, after the OS boots, I need to load my apps.

3) Now, the apps and the drivers communicate via a mmap'd region.

I need a deterministic way of allocating memory depending on my needs(interleave or localalloc).So I can't be at the mercy of either 'current' or 'global-policy' or anyone else.Also, why reference 'current' to begin with? And everytime I reference 'current' from within my driver, current points to 'work_for_cpu' kthread. So that clearly doesn't help.

> A device-centric interface--e.g.,
> 'get_free_pages_dev()'--could get the
> device/bus node affinity via dev_to_node() and then do the
> allocation/conversion.   I think this is
> close to what you're suggesting
> above. See dma_generic_alloc_coherent() [in
> arch/x86/kernel/pci-dma.c]
> for an example of a wrapper that does the device affinity
> lookup and
> allocation in one function.
> 

> Of course, you could just do this in your driver, as well.
> 
Very helpful thanks.I will mimic 'dma_generic_alloc_coherent' in my driver when I need local-node memory.


> > Also, is there a way to configure irqbalance and ask
> it to leave these
> > guys alone? Like a config file that says - leave
> these
> > irqs/pci-devices alone.For now I've shut down
> irqbalance.
> 
> You can set the environment variable
> IRQBALANCE_BANNED_INTERRUPTS--when
> starting irqbalance--to list of interrupts that irqbalance
> should ignore
> if you're using a version that supports that.  Check
> the init script
> that starts irqbalance on your distro of choice.
> 
aaaah...mine is old and I could see IRQBALANCE_BANNED_CPUS and not _INTERRUPTS.I will upgrade it.

> Regards,
> Lee

Thanks
Chetan Loke



      

