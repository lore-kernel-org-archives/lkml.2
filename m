Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab2HBOvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:51:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2HBOvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:51:38 -0400
Date: Thu, 2 Aug 2012 16:51:32 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
Message-ID: <20120802165132.1bf1e5d7@spider.haslach.nod.at>
In-Reply-To: <1343917741.25013.114.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
	<20120802161512.5ac7a303@spider.haslach.nod.at>
	<1343917741.25013.114.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 02 Aug 2012 17:29:01 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:

> On Thu, 2012-08-02 at 16:15 +0200, Richard Weinberger wrote:
> > > If I understand correctly, it can be only because of a bug. If I
> > > am correct, could you please add a 'dump_stack()' to improve the
> > > error report?
> > > 
> > 
> > This can happen if all PEBs are used and fastmap is unable to find
> > (or produce) an empty one.
> 
> In which situations is this possible? Could you please give an
> example?
> 

Every time fastmap writes a new fastmap to the flash it tries to get a
new PEB and returns the old one (used for the old fastmap) back to the
WL sub-system.
If no free PEBs are available (E.g Volume is full or the erase worker
is too slow) ubi_wl_get_fm_peb() returns NULL and fastmap reuses the
currently used PEB.
In this situation ubi_wl_get_fm_peb() may trigger such an error message.
If think we should get rid of the message as this is not an error
condition. It's a well known execution path.
The only bad thing that happens in such a situation is that a PEB gets
reused.

BTW: Which version of fastmap are you testing?

Thanks,
//richard
