Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2HBQyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:54:54 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab2HBQyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:54:52 -0400
Date: Thu, 2 Aug 2012 18:54:47 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
Message-ID: <20120802185447.35d237d9@spider.haslach.nod.at>
In-Reply-To: <1343925930.25013.163.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
	<20120802161512.5ac7a303@spider.haslach.nod.at>
	<1343917741.25013.114.camel@sauron.fi.intel.com>
	<20120802165132.1bf1e5d7@spider.haslach.nod.at>
	<1343924267.25013.156.camel@sauron.fi.intel.com>
	<20120802183210.7076aa48@spider.haslach.nod.at>
	<1343925930.25013.163.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 02 Aug 2012 19:45:30 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:

> Richard,
> 
> On Thu, 2012-08-02 at 18:32 +0200, Richard Weinberger wrote:
> > > This should not happen. Fastmap should _reserve_ enough of PEBs
> > > for it to operate. It should always find the PEB to write.
> > 
> > What is the benefit?
> > IOW what is wrong with the current approach?
> 
> Several reasons. The main is: fastmap will start consuming PEBs
> reserved for volumes when the amount of available PEBs is just enough
> to map all LEBs. This will break UBI liability.

Fastmap is also just a volume.
But if you want I can reserve PEBs for it.

> > Why?
> > If everything goes wrong, fastmap makes sure that no fastmap is on
> > flash.
> > In case of a powercut we fall back to scanning mode.
> > R/O mode is overkill IMHO.
> 
> So can I interpret this the following way. Not only fastmap give no
> guarantees that it exists after an unclean reboot, it does not even
> give guarantees that it exists after a clean reboot.

As I said several times before, fastmap was designed to be able to
fall back to scanning mode.
And yes, if there is currently no fastmap on flash (because you
attached from an old UBI volume) and there are no free PEBs you'll
have no fastmap on flash.
In all other cases you'll have one. At detach time fastmap checks
whether a fastmap is installed or not and installs one if needed.

> Unless I am confused, the fastmap design is over-simplified.

KISS.

Thanks,
//richard
