Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab0EOCrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:47:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47687 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756678Ab0EOCrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:47:02 -0400
Date: Fri, 14 May 2010 22:47:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Magnus Damm <magnus.damm@gmail.com>
cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       <linux-omap@vger.kernel.org>, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <AANLkTilL2mvqpwirTfJRWZFdrFJvSihnaY8-xao4pLpH@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005142238150.11498-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Magnus Damm wrote:

> I agree with you Tony. I thought shutting down CPUs for power
> managment purposes could be done without freezing user space. At least
> that's what we do today with SH-Mobile.

If you can shut down and restart CPUs in the time periods between 
transitions into and out of the idle loop, then yes -- userspace 
doesn't need to be suspended.  After all, if the idle loop is running 
then no user threads are runnable.  (Not necessarily true on SMP 
systems, but you know what I mean.)

> Still not sure how the system wide suspend is different from Runtime
> PM and CPUidle from the hardware perspective...

For embedded systems, apparently the difference is minimal.  For other
systems, like ACPI-based PCs, there is a big difference: Powering down
devices and CPUs still leaves large parts of the system running.

In addition, these larger systems generally don't have aggressive 
runtime PM support, so a significant fraction (maybe more than 50%) of 
devices won't be powered down when they are idle -- whereas system 
suspend powers virtually everything down.

Alan Stern

