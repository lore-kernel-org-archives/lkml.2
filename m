Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2GEUpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:45:55 -0400
Received: from waste.org ([173.11.57.241]:60233 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab2GEUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:45:53 -0400
Message-ID: <1341521150.4020.1298.camel@calx>
Subject: Re: [PATCH 02/10] random: use lockless techniques when mixing
 entropy pools
From: Matt Mackall <mpm@selenic.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
Date: Thu, 05 Jul 2012 15:45:50 -0500
In-Reply-To: <20120705194742.GG31225@thunk.org>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
	 <1341511933-11169-3-git-send-email-tytso@mit.edu>
	 <1341515412.4020.1230.camel@calx> <20120705194742.GG31225@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 15:47 -0400, Theodore Ts'o wrote:
> On Thu, Jul 05, 2012 at 02:10:12PM -0500, Matt Mackall wrote:
> > 
> > I don't think this will work correctly. It's important that simultaneous
> > _readers_ of the state get different results. Otherwise, you can get
> > things like duplicate UUIDs generated on different cores, something
> > that's been observed in the field(!). I thought I added a comment to
> > that effect some years back, but I guess not.
> 
> That's easy to fix; we just need to take a spinlock on the extract
> side.  The main issue is that Thomas very much doesn't want us to take
> a spinlock in the interrupt handler codepath.  But if we take a
> spinlock while extracting, that should take care of this concern.

Yup. This is why there's a separate _extract function to start with,
though this particular optimization hadn't been made yet. You do need to
continue to be sure to do the mix and extract in one operation though.

-- 
Mathematics is the supreme nostalgia of our time.


