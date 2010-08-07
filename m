Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0HGOrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 10:47:21 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:48459 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab0HGOrU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 10:47:20 -0400
X-AuditID: 12074423-b7cb4ae000000a9b-32-4c5d71eea033
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <201008071111.05585.rjw@sisk.pl>
Date: Sat, 7 Aug 2010 10:46:59 -0400
Cc: david@lang.hm, Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Transfer-Encoding: 8BIT
Message-Id: <7F55B423-3F07-4DF7-B958-7380FDD53545@mit.edu>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm> <20100807061558.GA28087@thunk.org> <201008071111.05585.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2010, at 5:11 AM, Rafael J. Wysocki wrote:

> But in principle that need not mean suspending the entire system.
> To get applications out of the way, you need to freeze user space.
> However, that's not sufficient, because in addition to that you need to
> prevent deactivate the majority of interrupt sources to avoid waking up the
> CPU (from C-states) too often.

True, but again, consider the MacBook.  If you plug in an iPod, the machine will wake up for *just* long enough to let the iTunes sync the iPod, but once its done, the machine goes back to sleep again immediately.   I doubt MacOS has something called a "suspend blocker" which prevents the machine from sleeping until iTunes finished, which when released, allows the machine to suspend again immediately.    But neither did I see any evidence that it took 30 seconds for some kludgy polling process to decide that iTunes was done, and to allow the MacBook to go back to sleep.    Clearly, the MacBook allows some interrupts through, and some USB insert events through, but clearly not all.  (Inserting a USB drive doesn't wake up the laptop; at least, not for long.)

Can we do something as smooth with a Linux desktop?  And if not, why not?   (Oh yeah, and wasn't this supposed to be the year of the Linux Desktop?  :-)

-- Ted

