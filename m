Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2GMDDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:03:33 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38837 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2GMDDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:03:31 -0400
Date: Thu, 12 Jul 2012 23:03:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>, rgetz@blackfin.uclinux.org,
        mpm@selenic.com
Subject: Re: feature-removal-schedule entry from 2009
Message-ID: <20120713030325.GB12245@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>,
	rgetz@blackfin.uclinux.org, mpm@selenic.com
References: <4FFDA698.2000707@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFDA698.2000707@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 11:15:20AM -0500, Rob Landley wrote:
> IRQF_SAMPLE_RANDOM is 3 years past its sell-by date in
> feature-removal-schedule:
> 
> What:   IRQF_SAMPLE_RANDOM
> Check:  IRQF_SAMPLE_RANDOM
> When:   July 2009
> 
> Why:    Many of IRQF_SAMPLE_RANDOM users are technically bogus as
>         entropy sources in the kernel's current entropy model. To
>         resolve this, every input point to the kernel's entropy pool
>         needs to better document the type of entropy source it actually
>         is. This will be replaced with additional add_*_randomness
>         functions in drivers/char/random.c
> 
> Who:    Robin Getz <rgetz@blackfin.uclinux.org>
>         & Matt Mackall <mpm@selenic.com>
> 
> There are 12 remaining uses under drivers/ and 14 more under arch/, the
> rest of the hits look like infrastructure implementing it.
> 
> Should I run those files through bother-maintainer.pl and try to get
> people to stop it, or is there a plan underway I don't know about?

I was going to deal with that in the new /dev/random tree; once those
changes go in, IRQF_SAMPLE_RANDOM effectively becomes a no-op.  But
I'd prefer that the ordering be that we get the new
sample_interrupt_randomness() changes in first, and then remove the
IRQF_SAMPLE_RANDOM.

I've just been slammed with work, processing patches for the ext4
merge window, and kernel summit planning, and quite frankly, I
considered this to be relatively low priority --- especially since we
no shortage of IRQF_* flag bits, and once the new
sample_interrupt_randomness() goes in, the flag is a complete no-op.

			      	       	   	- Ted
