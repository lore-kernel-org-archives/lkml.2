Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1BHSk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:40:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27387 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab1BHSkX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Feb 2011 13:40:23 -0500
Date: Tue, 8 Feb 2011 13:39:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
Message-ID: <20110208183937.GD4606@dumpdata.com>
References: <20110205200108.921707839@linutronix.de>
 <4D50641B.2090006@goop.org>
 <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
 <4D506AE6.6080900@goop.org>
 <1297173811.9388.95.camel@zakaz.uk.xensource.com>
 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
 <1297177506.9388.135.camel@zakaz.uk.xensource.com>
 <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>
 <20110208162045.GB4606@dumpdata.com>
 <alpine.LFD.2.00.1102081829330.31804@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102081829330.31804@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D518E0B.00FE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > <scratches his head> The rework was in Xen code not in generic, and
> > the only generic changes that are in there ..  are your code?
> 
> The point is:
> 
> If you play with generic irq code in Xen in some weird way then you
> basically block me to cleanup something in the core code w/o breaking
> Xen. I wanted to move IRQ_SUSPENDED to a different field and
> accidentally noticed that Xen was fiddling with in -next.

Aaaaah. I somehow thought the problems were with code proposed for
2.6.39, but you are referring to: "xen: events: do not unmask event channels
on resume" (6903591f314b8947d0e362bda7715e90eb9df75e) which was added way
back in November (post 2.6.37 time-frame) - and is already in Linus tree.

OK, now that I've that clear in my head (sorry about this confusion):
> 
> So that's what I'm grumpy about. You hack away in Xen and claim it's
> confined to your code, while in reality it is _NOT_.

.. I can quite understand why you are unhappy about this.
> 
> Again, if there is a problem with the generic code then talk to me.

Absolutely. We appreciate you being quite dilligient about other
sub-platforms and sorry for this screwup.

> 
> That's going to be impossible anyway when I'm done with the
> encapsulation.

Any thoughts on how to fix that code Xen code for that issue?

> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
