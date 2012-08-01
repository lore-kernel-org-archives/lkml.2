Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2HAM2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:28:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36678 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2HAM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:28:31 -0400
Date: Wed, 1 Aug 2012 14:28:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
Message-ID: <20120801122821.GA28650@somewhere.redhat.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
 <1343660892.20897.3.camel@twins>
 <20120730155059.GB17078@somewhere.redhat.com>
 <20120731070640.GA2950@gmail.com>
 <20120731104845.GC17078@somewhere.redhat.com>
 <20120731145742.GA6934@gmail.com>
 <1343751262.20897.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343751262.20897.29.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 06:14:22PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-07-31 at 16:57 +0200, Ingo Molnar wrote:
> > 
> > 'callback', while a longer word, is almost always used as a noun 
> > within the kernel - and it also has a pretty narrow meaning. 
> 
> An altogether different naming would be something like:
> 
> struct user_kernel_tracking {
> 	int want_uk_tracking;
> 	enum {
> 		in_kernel = 0,
> 		in_user,
> 	} uk_state;
> };
> 
> 

You bet we might also extend this to track guest as well in the future
because it appears that we could also enter into RCU extended quiescent
state when we run in guest.

So we probably need to generalize a bit more. Some naming based on
"code domain"?

struct code_domain {
	int is_tracking;
	enum {
		in_kernel,
		in_user,
		in_guest
	} state;
}

