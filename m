Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2APWFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:05:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2APWFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:05:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.2.0-07927-gc49c41a: s2ram: Device 'machinecheck1' does not have a release() function, it is broken and must be fixed
Date: Mon, 16 Jan 2012 23:08:49 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Tony Luck <tony.luck@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com
References: <Pine.LNX.4.44L0.1201161645490.11125-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1201161645490.11125-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201162308.49530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 16, 2012, Alan Stern wrote:
> On Mon, 16 Jan 2012, Rafael J. Wysocki wrote:
> 
> > On Monday, January 16, 2012, Srivatsa S. Bhat wrote:
> 
> > > Just to re-instate, an end-user need not really worry about this warning
> > > too much since this was there before (at a different place, and hidden)
> > > when things were working fine... Hence it would be worthwhile to fix
> > > this warning "correctly" if possible, than just do a quick and dirty
> > > "silence the warning" kind of workaround. 
> > 
> > Well, since there's nothing to release in there, I really see only two
> > possible "fixes": either silence the warning the way you describe, or
> > remove it from the core.
> 
> No, the right fix is to release something.  The device structures
> should be allocated dynamically, not statically.  Greg's suggestion of
> using a set of per-cpu pointers to dynamically-allocated structures
> sounds right.

OK, so the source of the problem is that the device structure is statically
allocated, right?

Rafael
