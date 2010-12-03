Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0LCVX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:23:59 -0500
Received: from nm13.bullet.mail.sp2.yahoo.com ([98.139.91.83]:25540 "HELO
	nm13.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750837Ab0LCVX6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:23:58 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 678208.96110.bm@omp1020.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zTZ7ej+LVqMUyu9oa70U2HqBlZfU43933qSg7+CmibnXOrmhsbXWhP6TMXcmpSZ1m87GoUfz3ajkNu60K8FFuWqEwjoHiIsG9TrP7v3FLW59P/z88EGqny4Q4IW6RiGGlY5MPTtcP9ZcidFzRV0wjRL8wzx/OvoyxO51Ib6qmpE=;
Message-ID: <268480.24096.qm@web111714.mail.gq1.yahoo.com>
X-YMail-OSG: ni2bjv8VM1k3Lsd77Xfuizob8FoAUEXQIDYxC8DH.Ol2IvI
 _XWj0t0._ttIbrg.A7EJmbSOWjHb2lZHSCO2VTpsQY0Uaz3ON1X5.Lj4Uf3S
 ntfb0rGkg8LRt46bOtvHMVOPXiIUvbCsH.M0c3ehr9yFGC4lFAC10Yx7xCEV
 5Cgd5DZpgljn83BRHjLLhVQAqLeiPmXZnyQGlgad.sANeeDtVQ1pjWj.Jx_a
 pUi_QrdiZ3h5HGuhSJDQg7mPvNDkm.YL4bJ890YjSfPTQRjml8GF8LHL4i5s
 ZiTEVJ3mkJAvRy1p4IRqyMG4WF2L3YPwhEXKBgahRwj.VHFlAK6OYrGuFwiv
 mBviLvdcEuxIDYZdZeATs2JV1yAHU5wiIV6K.l00Kg4Y5
X-Mailer: YahooMailClassic/11.4.7 YahooMailWebService/0.8.107.285259
Date: Fri, 3 Dec 2010 13:23:56 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: edac_core: crashes on shutdown
To: Tobias Karnat <tobias.karnat@googlemail.com>,
        Borislav Petkov <bp@amd64.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101202183724.GH27263@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 12/2/10, Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <bp@amd64.org>
> Subject: Re: edac_core: crashes on shutdown
> To: "Tobias Karnat" <tobias.karnat@googlemail.com>
> Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Doug Thompson" <norsk5@yahoo.com>
> Date: Thursday, December 2, 2010, 11:37 AM
> On Thu, Dec 02, 2010 at 01:05:01PM
> -0500, Tobias Karnat wrote:
> > This patch fixed it.
> > I have rebooted five times and it does not crash
> anymore.
> > 
> > Thank you.
> 
> Thanks for testing and taking pictures :). I'll send it to
> Linus before
> .37 is out.

great find. I haven't had time to do much with this one (sorry). Just started a new job (in user space now, instead of kernel space) in the past 2 weeks. As things settle down, I hope to have some cycles back on this.

doug t

> 
> > Btw, are there any information available regarding the
> NMI option?
> > 
> > parm:    edac_op_state:EDAC Error
> Reporting state: 0=Poll,1=NMI (int)
> > 
> > In edac.txt NMI is listed under FUTURE HARDWARE
> SCANNING.
> 
> Well, looking at
> <arch/x86/kernel/traps.c:mem_parity_error()> this
> should already work. But it is kinda of a hack, if I'm
> reading Doug
> correctly: http://lkml.org/lkml/2010/9/21/144
> 
> And yes, using some kind of an interrupt is much better
> than polling but
> I don't know whether there's a single interrupt source for
> the error
> types all edac drivers can decode and report. In the
> amd64_edac case,
> we're piggybacking on MCE, for example. This was actually
> the initial
> reason for 00740c58541b6087d78418cebca1fcb86dc6077d and
> dropping polling
> from that driver.
> 
> Doug, any additions?

I had an implementation for NMI processing, but as pointed out, we don't have a single cause source that applies everyone, and I (we) didn't have enough boxes to try it out on.  The documentation indicated a future feature with NMI, but it has faded over time and NMI patch (at sourceforge) is way stale.

I whole new R&D stage would need to be done again to recapture all the old information and new possible implementation changes that have occurred in the past 4 years (if any).  

The NMI/parity was a hack that was used to solved a problem back in 2005/2006 at Linux Networx (now defunct), but it worked then.  It was very much a lower priority thing once it worked on many machines. Today, it need a re-eval

doug thompson


 
