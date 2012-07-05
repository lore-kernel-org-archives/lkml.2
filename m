Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab2GETsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:48:10 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37093 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2GETsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:48:08 -0400
Date: Thu, 5 Jul 2012 15:47:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
Subject: Re: [PATCH 02/10] random: use lockless techniques when mixing
 entropy pools
Message-ID: <20120705194742.GG31225@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
	zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
	jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-3-git-send-email-tytso@mit.edu>
 <1341515412.4020.1230.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341515412.4020.1230.camel@calx>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 02:10:12PM -0500, Matt Mackall wrote:
> 
> I don't think this will work correctly. It's important that simultaneous
> _readers_ of the state get different results. Otherwise, you can get
> things like duplicate UUIDs generated on different cores, something
> that's been observed in the field(!). I thought I added a comment to
> that effect some years back, but I guess not.

That's easy to fix; we just need to take a spinlock on the extract
side.  The main issue is that Thomas very much doesn't want us to take
a spinlock in the interrupt handler codepath.  But if we take a
spinlock while extracting, that should take care of this concern.

	       		   	       	    - Ted
