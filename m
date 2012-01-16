Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab2APVtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:49:10 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52449 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756656Ab2APVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:49:08 -0500
Date: Mon, 16 Jan 2012 16:49:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tony Luck <tony.luck@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, <prasad@linux.vnet.ibm.com>
Subject: Re: 3.2.0-07927-gc49c41a: s2ram: Device 'machinecheck1' does not
 have a release() function, it is broken and must be fixed
In-Reply-To: <201201162148.47996.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1201161645490.11125-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012, Rafael J. Wysocki wrote:

> On Monday, January 16, 2012, Srivatsa S. Bhat wrote:

> > Just to re-instate, an end-user need not really worry about this warning
> > too much since this was there before (at a different place, and hidden)
> > when things were working fine... Hence it would be worthwhile to fix
> > this warning "correctly" if possible, than just do a quick and dirty
> > "silence the warning" kind of workaround. 
> 
> Well, since there's nothing to release in there, I really see only two
> possible "fixes": either silence the warning the way you describe, or
> remove it from the core.

No, the right fix is to release something.  The device structures
should be allocated dynamically, not statically.  Greg's suggestion of
using a set of per-cpu pointers to dynamically-allocated structures
sounds right.

Alan Stern

