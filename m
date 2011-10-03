Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1JCUf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:35:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:53467 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab1JCUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:35:49 -0400
Date: Mon, 3 Oct 2011 22:35:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
In-Reply-To: <1317668908.11991.20.camel@dagon.hellion.org.uk>
Message-ID: <alpine.LFD.2.02.1110032229250.1489@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>  <alpine.LFD.2.02.1110032033530.1489@ionos> <1317668908.11991.20.camel@dagon.hellion.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Ian Campbell wrote:
> On Mon, 2011-10-03 at 19:42 +0100, Thomas Gleixner wrote:
> > On Mon, 3 Oct 2011, Ian Campbell wrote:
> > > I can see a few options for how I might go about solving this in a
> > > non-hacky way, which approach do you think would be preferable:
> > 
> > The question is whether you need to disable the IPI interrupt at
> > all. If not, we have a flag for that.
> 
> We already that flag for these (I think that was why it was added even).
> The issue is that in the resuming domain on the other side event
> channels all start off masked and something needs to unmask them.

Bah.
 
> > >       * Add "IRQF_RESUME_EARLY", driven from syscore_resume, and use it
> > >         for these interrupts.
> > 
> > That's the preferable solution, as we could use that for PPC as well,
> > unless we can move stuff around, so we disable stuff later.
> 
> OK

I guess we should go down that road then.

Thanks,

	tglx
