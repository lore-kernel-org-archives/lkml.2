Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2GPPVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:21:49 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39311 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2GPPVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:21:47 -0400
Date: Mon, 16 Jul 2012 11:21:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>, rgetz@blackfin.uclinux.org,
        mpm@selenic.com
Subject: Re: feature-removal-schedule entry from 2009
Message-ID: <20120716152140.GA27656@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>,
	rgetz@blackfin.uclinux.org, mpm@selenic.com
References: <4FFDA698.2000707@landley.net>
 <20120713030325.GB12245@thunk.org>
 <50032B11.7070505@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50032B11.7070505@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 03:41:53PM -0500, Rob Landley wrote:
> Does it become a "please add a call to sample_interrupt_randomness()"
> reminder, or will the infrastructure figure out when to do that outside
> the driver?

The patches in the random.git tree unconditionally call
add_interrupt_randomness() in handle_irq_event_percpu(), so the
drivers don't need to do anything at this point.

> And will this upcoming patch set remove 'em, or leave the NOP debris
> there?

The current status is here:

http://git.kernel.org/?p=linux/kernel/git/tytso/random.git;a=summary

At this point the flag is a no-op, and can be removed.  This close to
the merge window, I don't think I'm going to have time to create
patches which remove the flag from all of the drivers, but it's
basically clean up work, and having the extra bit set isn't going to
harm anyone.

The only thing that might require a bit of care is the usage in
arch/um, where someone needs to do a bit more analysis to see if it's
just a matter of removing the flag from the call to request_irq().  My
current thinking was to merge the new interrupt structure during this
merge window, and then clean up the NOP debris during the next
development cycle.

						- Ted

