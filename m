Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2DWLiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:38:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2DWLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:38:03 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=qp4yekXCDa0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=-_Ve-O37v_gQ9O5ZX24A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335181077.28106.93.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 12/16] rtmutex: turn the plist into an rb-tree.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 07:37:57 -0400
In-Reply-To: <1335170023.28150.97.camel@twins>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-13-git-send-email-juri.lelli@gmail.com>
	 <1334178715.23924.308.camel@gandalf.stny.rr.com>
	 <1335170023.28150.97.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 10:33 +0200, Peter Zijlstra wrote:
> On Wed, 2012-04-11 at 17:11 -0400, Steven Rostedt wrote:
> > 
> > I have to ask. Why not just add a rbtree with a plist? That is, add all
> > deadline tasks to the rbtree and all others to the plist. As plist has a
> > O(1) operation, and rbtree does not. We are making all RT tasks suffer
> > the overhead of the rbtree.
> 
> You always love to add complexity to stuff before making it work, don't
> you ;-)

Nah, I like the make it work first, then optimize. But I wanted to bring
this up as a concern. After benchmarks, it may not be an issue anyway. I
just don't want to forget about doing the benchmarks.

-- Steve


