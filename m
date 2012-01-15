Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2AOCfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 21:35:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2AOCfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 21:35:19 -0500
Date: Sat, 14 Jan 2012 18:34:04 -0800
From: Greg KH <gregkh@suse.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
Message-ID: <20120115023404.GA4268@suse.de>
References: <20120114144938.GA32033@suse.de>
 <Pine.LNX.4.44L0.1201141121300.7598-100000@netrider.rowland.org>
 <CA+8MBbJS0YNUmqOV_d6hug=FesghYay4gQGdaBX_OhYt6sbF-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbJS0YNUmqOV_d6hug=FesghYay4gQGdaBX_OhYt6sbF-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 06:05:24PM -0800, Tony Luck wrote:
> On Sat, Jan 14, 2012 at 8:30 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > The driver core isn't designed to handle device structures that get
> > unregistered and then spring back to life; callers are supposed to
> > allocate a fresh new structure instead.
> 
> Does every caller use "kzalloc()" for this fresh new structure (or even
> for the original registration) rather than "kmalloc()"?

They better, as that's what they are required to do :)

The kernel would be crashing with slab debugging enabled, if it wasn't
so today.

thanks,

greg k-h
