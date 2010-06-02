Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0FBHXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:23:09 -0400
Received: from www.tglx.de ([62.245.132.106]:43257 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab0FBHXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:23:07 -0400
Date: Wed, 2 Jun 2010 09:21:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <AANLkTikI8HUkwA1P-ozAcxoVrlQDmHAI-RbvH5JrjsDT@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006020920200.2933@localhost.localdomain>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk> <20100527220949.GB10602@srcf.ucam.org> <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <20100527223605.GB11364@srcf.ucam.org> <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
 <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop> <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com> <1275120618.27810.12699.camel@twins> <1275149418.4503.128.camel@mulgrave.site> <alpine.LFD.2.00.1005312231120.2933@localhost.localdomain>
 <1275340869.2823.344.camel@mulgrave.site> <alpine.LFD.2.00.1005312343290.2933@localhost.localdomain> <AANLkTinwvkJRU0JjJdNrGfXWYpQMIr8bO3BZxcXubt_Z@mail.gmail.com> <alpine.LFD.2.00.1006011257580.2933@localhost.localdomain> <AANLkTimTO5n_s9JZAcFJOhMlPMtsOrogx-5S5nykOWtY@mail.gmail.com>
 <alpine.LFD.2.00.1006020856550.2933@localhost.localdomain> <AANLkTikI8HUkwA1P-ozAcxoVrlQDmHAI-RbvH5JrjsDT@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1233818980-1275463314=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1233818980-1275463314=:2933
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 2 Jun 2010, Arve Hjønnevåg wrote:
> 2010/6/2 Thomas Gleixner <tglx@linutronix.de>:
> > On Tue, 1 Jun 2010, Arve Hjønnevåg wrote:
> >> Deferring the the timers forever without stopping the clock can cause
> >> problems. Our user space code has a lot of timeouts that will trigger
> >> an error if an app does not respond in time. Freezing everything and
> >> stopping the clock while suspended is a lot simpler than trying to
> >> stop individual timers and processes from running.
> >
> > And resume updates timekeeping to account for the slept time. So the
> 
> No, for the monotonic clock it does the opposite. The hardware clock
> is read on resume and the offset is set so the monotonic clock gets
> the same value as it had when suspend was called.

Grr, yes. Misread the code. -ENOTENOUGHCOFFEE

Thanks,

	tglx
--8323328-1233818980-1275463314=:2933--
