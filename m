Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1JQIvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 04:51:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:53380 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1JQIvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 04:51:10 -0400
Date: Mon, 17 Oct 2011 10:51:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] Re: xen: IPI interrupts not resumed early enough on
 suspend/resume
In-Reply-To: <1318713254.11016.52.camel@dagon.hellion.org.uk>
Message-ID: <alpine.LFD.2.02.1110171049440.3240@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>  <alpine.LFD.2.02.1110032033530.1489@ionos>  <1317668908.11991.20.camel@dagon.hellion.org.uk>  <alpine.LFD.2.02.1110032229250.1489@ionos>  <1318001583.21903.355.camel@zakaz.uk.xensource.com> 
 <alpine.LFD.2.02.1110071822160.3240@ionos>  <1318251990.21903.433.camel@zakaz.uk.xensource.com>  <1318598637.21903.889.camel@zakaz.uk.xensource.com> <1318713254.11016.52.camel@dagon.hellion.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, Ian Campbell wrote:

> On Fri, 2011-10-14 at 14:23 +0100, Ian Campbell wrote:
> > Ping? The original issue has made it into longterm-2.6.32.y and then
> > onto Debian (bug #644604) so people keep asking me about it...
> 
> Sorry, the previous version had a warning in it (was missing the return
> type for resume_irqs), fixed up version follows.
> 
> I noticed that the backport to longterm 2.6.32 won't work since syscore
> isn't available back then. I think one approach for the backport would
> be to call irq_pm_syscore_resume() directly from sysdev_resume(), does
> that sound sensible?

I think so. Can you please add a description (or the five lines patch)
for the stable folks to the changelog, so they don't have to dig
around ?
 
Thanks,

	tglx
