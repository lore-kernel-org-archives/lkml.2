Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2APBPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 20:15:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:44390 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab2APBPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 20:15:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="56734721"
Subject: Re: [git patches] libata updates for 3.3
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4F12E57E.3090805@garzik.org>
References: <20120109003255.GA6598@havoc.gtf.org>
	 <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
	 <4F12E57E.3090805@garzik.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 09:15:34 +0800
Message-ID: <1326676534.13517.3.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 09:41 -0500, Jeff Garzik wrote:
> On 01/14/2012 12:21 AM, Linus Torvalds wrote:
> > On Sun, Jan 8, 2012 at 4:32 PM, Jeff Garzik<jeff@garzik.org>  wrote:
> >>
> >> Summary (very little excitement at all this time):
> >>
> >> 0) Will play around with git signed tags with the next update.
> >>
> >> 1) PM improvements, including runtime suspend/resume work
> >
> > Hmm. I don't know if this comes from the PM improvements or even this
> > particular pull, but links that aren't connected are *really* slow.
> >
> > Annoyingly so.
> >
> > My Macbook Air that I finally can resume reliably again used to come
> > back almost immediately from resume. No longer. And the reason seems
> > to be this:
> >
> >   [  243.306149] ata_piix 0000:00:1f.2: setting latency timer to 64
> >   [  243.306180] bcma: Found rev 6 PMU (capabilities 0x108C2606)
> >   [  246.579648] ata1.01: failed to resume link (SControl 0)
> >   [  246.735472] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >   [  246.735485] ata1.01: SATA link down (SStatus 0 SControl 0)
> >   [  246.743632] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES)
> > filtered out
> >   [  246.744353] ata1.00: configured for UDMA/100
> >   [  246.744537] sd 0:0:0:0: [sda] Starting disk
> >   [  247.769806] ata2.00: failed to resume link (SControl 0)
> >   [  248.796207] ata2.01: failed to resume link (SControl 0)
> >   [  248.807665] ata2.00: SATA link down (SStatus 4 SControl 0)
> >   [  248.807681] ata2.01: SATA link down (SStatus 0 SControl 0)
> >   [  248.808338] PM: resume of devices complete after 5511.027 msecs
> >   [  248.882074] PM: Finishing wakeup.
> >
> > Notice the basically five-second timeout all basically for "failed to
> > resume link: for things that didn't have anything connected to them
> > anyway.
> >
> > This is a bog-standard Intel controller, there's nothing odd there.
> >
> > I'm pretty sure this used to be much faster, but I haven't bisected
> > any of it (and with all the problems I had with resume both due to
> > wireless and MCE, I really wouldn't want to even try).
> >
> > Taking 5.5 seconds to come back from suspend-to-ram really is too
> > long. Not *all* of it is the SATA part, but a lot of it is.
> >
> > For ATA suspend/resume, could we perhaps only resume the ports that
> > *used* to have something on them? And then, if somebody has plugged
> > something into the others, not consider that a resume thing at all,
> > but a hotplug thing that happens *after* the resume?
> >
> > If it takes five seconds to notice new hardware after a resume, nobody
> > cares. But the disk we had before obviously needs to get resumed.. But
> > it does seem like it's the "no link" part that takes long.
> 
> We definitely notice new hardware after a resume, but you're right -- it 
> should not take that long to work through ports that are empty.
> 
> Will take a look tomorrow (kid->doctor+relatives today, uff) at the most 
> recent PM push; my quick testing did not show any problems, but 
> suspend/resume varies widely across hardware platforms.  I think I might 
> even have a MacBook I can test.  Apple platforms test to be weird too...  ;)

I just did a quick test with latest git head(122804e) and didn't find
the problem either.

I'll test other machines.

Lin Ming

> 
> 	Jeff
> 
> 
> 
> 
> 


