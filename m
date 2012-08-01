Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2HAMp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:45:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65230 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2HAMp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:45:27 -0400
Date: Wed, 1 Aug 2012 14:45:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
Message-ID: <20120801124513.GB28650@somewhere.redhat.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
 <1343660892.20897.3.camel@twins>
 <20120730155059.GB17078@somewhere.redhat.com>
 <20120731070640.GA2950@gmail.com>
 <20120731104845.GC17078@somewhere.redhat.com>
 <20120731145742.GA6934@gmail.com>
 <1343751262.20897.29.camel@twins>
 <20120801122821.GA28650@somewhere.redhat.com>
 <1343824983.27983.74.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343824983.27983.74.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:43:03AM -0400, Steven Rostedt wrote:
> On Wed, 2012-08-01 at 14:28 +0200, Frederic Weisbecker wrote:
> > On Tue, Jul 31, 2012 at 06:14:22PM +0200, Peter Zijlstra wrote:
> 
> > So we probably need to generalize a bit more. Some naming based on
> > "code domain"?
> > 
> > struct code_domain {
> > 	int is_tracking;
> > 	enum {
> > 		in_kernel,
> > 		in_user,
> > 		in_guest
> > 	} state;
> > }
> 
> Is there a fundamental difference between 'in_user' and 'in_guest'
> though?

Probably not from RCU POV. But the cputime is not accounted the same.
