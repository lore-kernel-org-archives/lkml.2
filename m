Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0HQPAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:00:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38906 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750837Ab0HQPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:00:18 -0400
Date: Tue, 17 Aug 2010 11:00:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, <paulmck@linux.vnet.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, <david@lang.hm>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <arve@android.com>, <mjg59@srcf.ucam.org>, <pavel@ucw.cz>,
        <florian@mickler.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <menage@google.com>, <david-b@pacbell.net>, <James.Bottomley@suse.de>,
        <arjan@infradead.org>, <swmike@swm.pp.se>, <galibert@pobox.com>,
        <dipankar@in.ibm.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <201008171518.14069.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1008171056100.1656-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Rafael J. Wysocki wrote:

> > In general, we try to keep such complexity out of the
> > kernel, but not always; there are compelling cases for putting
> > complexity in the kernel to provide uniformity and flexibility (e.g.
> > application state save/restore vs. system-wide checkpoints, the former
> > preserves the "if it can be done outside the kernel, it should be",
> > while the latter provides much greater flexibility and avoids the need
> > to port applications to potentially incompatible or unportable state
> > saves/restore libraries).
> 
> I understand that and IMO it should be decided on the case-by-case basis.
> In this particular case, however, I don't think it's appropriate to use the
> interface designed with user space in mind for implementing a kernel-based
> mechanism.

Putting the "opportunistic suspend" loop into the kernel doesn't save 
as much as one might think.  The loop itself is quite simple, and the 
task switch it entails is required in any case (since suspend must be 
carried out within a process context).  Putting it in the kernel would 
save a few user/kernel context switches, not enough to matter IMO.  And 
it wouldn't offer any greater flexibility -- it might even cut down the 
flexibility.

Alan Stern

