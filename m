Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2HBQcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:32:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab2HBQcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:32:15 -0400
Date: Thu, 2 Aug 2012 18:32:10 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
Message-ID: <20120802183210.7076aa48@spider.haslach.nod.at>
In-Reply-To: <1343924267.25013.156.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
	<20120802161512.5ac7a303@spider.haslach.nod.at>
	<1343917741.25013.114.camel@sauron.fi.intel.com>
	<20120802165132.1bf1e5d7@spider.haslach.nod.at>
	<1343924267.25013.156.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 02 Aug 2012 19:17:47 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:

> On Thu, 2012-08-02 at 16:51 +0200, Richard Weinberger wrote:
> > Every time fastmap writes a new fastmap to the flash it tries to
> > get a new PEB and returns the old one (used for the old fastmap)
> > back to the WL sub-system.
> 
> OK.
> 
> > If no free PEBs are available (E.g Volume is full or the erase
> > worker is too slow) ubi_wl_get_fm_peb() returns NULL and fastmap
> > reuses the currently used PEB.
> 
> This should not happen. Fastmap should _reserve_ enough of PEBs for it
> to operate. It should always find the PEB to write.

What is the benefit?
IOW what is wrong with the current approach?

> Just like if you create a volume maximum possible size, we guarantee
> that you can fill it with data, and UBI will find enough PEBs for
> that.
> 
> Just like we always have enough PEBs for the volume table.
> 
> The above things are UBI's liabilities.
> 
> In the situation when a lot of PEBs became bad, UBI will switch to R/O
> mode with a scary message if it notices that it does not have enough
> PEBs to satisfy all the liabilities.
> 
> And this is why we reserve 2% of PEBs for bad PEBs handling.

Of course fastmap could also do something like that, but I don't really
see a benefit in this.

> > In this situation ubi_wl_get_fm_peb() may trigger such an error
> > message. If think we should get rid of the message as this is not
> > an error condition. It's a well known execution path.
> 
> Unless I am confused, this should lead to switching to R/O mode
> instead, just like we do when we write to an LEB and do not find a
> PEB to map to.

Why?
If everything goes wrong, fastmap makes sure that no fastmap is on
flash.
In case of a powercut we fall back to scanning mode.
R/O mode is overkill IMHO.

Thanks,
//richard

