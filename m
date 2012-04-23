Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2DWIeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:34:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2DWIeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:34:10 -0400
Message-ID: <1335170023.28150.97.camel@twins>
Subject: Re: [PATCH 12/16] rtmutex: turn the plist into an rb-tree.
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 10:33:43 +0200
In-Reply-To: <1334178715.23924.308.camel@gandalf.stny.rr.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-13-git-send-email-juri.lelli@gmail.com>
	 <1334178715.23924.308.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 17:11 -0400, Steven Rostedt wrote:
> 
> I have to ask. Why not just add a rbtree with a plist? That is, add all
> deadline tasks to the rbtree and all others to the plist. As plist has a
> O(1) operation, and rbtree does not. We are making all RT tasks suffer
> the overhead of the rbtree.

You always love to add complexity to stuff before making it work, don't
you ;-)

I'm not quite convinced the plist stuff is _that_ much faster, anyway,
its all a stop-gap measure until we can do proper BWI which would wipe
all this code anyway.
