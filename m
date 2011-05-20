Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935024Ab1ETDwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:52:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:57121 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275Ab1ETDwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:52:34 -0400
Subject: Re: [bg-linux] [PATCH 6/7] [RFC] enable early TLBs for BG/P
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kazutomo Yoshii <kazutomo@mcs.anl.gov>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
In-Reply-To: <4DD5E218.5030508@mcs.anl.gov>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-6-git-send-email-ericvh@gmail.com>
	 <1305851941.7481.92.camel@pasglop>
	 <BANLkTinAqeu7C+U_HFrOAOctFTuSUwG-iA@mail.gmail.com>
	 <1305856442.7481.120.camel@pasglop>  <4DD5E218.5030508@mcs.anl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 13:52:21 +1000
Message-ID: <1305863541.7481.132.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately, the firmware is also required:
> - to configure Blue Gene Interrupt Controller(BIC)

Can't we just write bare metal code for that ?

> - to configure Torus DMA unit. e.g. fifo

Same

> - to configure global interrupt (even we don't use, we need to disable 
> some channel correctly)

Same

> - to access node personality information (node id, DDR size, HZ, etc) or 
> maybe we can directly access SRAM?

That should be turned into device-tree at boot, possibly from a
bootloader or from the zImage wrapper.

> etc, etc.
> 
> >> As such the IO Node guys, the Compute Node Kernel guys and the
> >> ZeptoOS guys use it quite a bit.  The kittyhawk guys on the other hand
> >> barely use it at all, in fact I believe they do all the interaction with
> >> it during uboot and then shut it off.
> >>      
> >    
> (I'm one of the ZeptoOS guys, btw)

Heh ok.

> As a regular ppc linux usage, our firmware dependency is minimum as well.
> However,  with our HPC extension, the firmware functions are called when
> it configures BGP specific network hardware.
> 
> We are not planning to submit our HPC extension here anytime soon
> because our work is very special purpose and includes lots of dirty hack 
> right now.

Ok.

Cheers,
Ben.

> Thanks,
> Kaz
> > I would prefer that approach.
> >
> >    
> >> IIRC, the sticky question is RAS support, there are certain things it
> >> wants to jump to firmware to deal with and expects things to be mapped
> >> an pinned into memory.
> >>
> >> Furthermore, I think it may make assumptions about where in the TLB the
> >> mappings are.
> >>      
> > This is gross, especially on a system with only 64 SW loaded TLB
> > entries :-(
> >
> >    
> >> Since the kittyhawk guys
> >> obviously ignore this by shutting it down, its not clear just how
> >> important this is.  I'm game to
> >> try the dynamic mapping as you suggest if you would prefer it.
> >>      
> > I would yes, we can sort things out later for RAS.
> >
> >    
> >> Its worth mentioning that I believe with BG/Q, the plan is to rely on
> >> the firmware even more extensively, but I haven't looked at any of the code yet to verify
> >> whether or not this is true.
> >>      
> > This is tantamount to linking a binary blob with the kernel ... it's a
> > fine line. At some point we might refuse the patches if they go too far
> > in that direction.
> >
> > Cheers,
> > Ben.
> >
> >    
> >>       -eric
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>      
> >
> > _______________________________________________
> > bg-linux mailing list
> > bg-linux@lists.anl-external.org
> > https://lists.anl-external.org/mailman/listinfo/bg-linux
> > http://bg-linux.anl-external.org/wiki
> >    


