Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1HCVgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:36:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52907 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1HCVgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:36:39 -0400
Subject: Re: [PATCH RFCv2 0/8] sched: Enforce order of leaf CFS runqueues
 (and list cleanup)
From: Peter Zijlstra <peterz@infradead.org>
To: Jan =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4E39B806.6020405@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <4E39B806.6020405@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 23:35:45 +0200
Message-ID: <1312407345.1147.329.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 23:05 +0200, Jan Schönherr wrote:
> Hi Peter,
> 
> Am 27.07.2011 21:10, schrieb Jan H. Schönherr:
> > Patch 1: After inventing __list_link(), I realized, that this
> > 	 function already existed, but with a different name.
> > 
> > 	 This patch just does some renaming. Not really needed,
> > 	 but if I use the old naming in patch 2 it's really 
> > 	 hard to understand what's actually going on.
> > 
> > 	 It also helps to increase the readability of the existing
> > 	 code, see patches 6-8.
> > 
> > Patch 2: This introduces new list functions to splice RCU lists
> > 	 and handle deleted RCU list entries.
> > 
> > Patch 3: The actual bugfix.
> > 
> > Patch 4+5: Follow-ups to patch 1. Some more renaming and use of
> > 	   appropriate functions.
> > 
> > Patch 6: Another follow-up to patch 1, improving the readability of
> > 	 the list routines a bit.
> > 
> > Patch 7+8: Follow-ups to patch 2. Make use of the introduced
> >            functionality in the already existing code.
> 
> 
> I am wondering, whether v3 should consist basically only of
> patches 2 and 3, i. e. the minimal approach, or if you would
> take all of them?
> 
> If you prefer the minimal version, I would make another patch
> set out of the other patches. But as there seems to be no official
> maintainer for list related functionality, I would appreciate
> some hints who I should put on the TO/CC list.

Ha, good question, so what we can do is I can take the minimal patch-set
through the scheduler tree once we un-confuse ourself with those list
ops and at least one of the Paul's has had a look too (such tricksy code
deserves more eye balls).

After that we can maybe trick Andrew Morton into carrying the generic
cleanups etc.. at any rate, try and Cc everybody who's files you're
touching on the various patches (scripts/get_maintaineres.pl --no-git or
so should get you an idea).

Alternatively we could try and trick Ingo into pushing them, but
generally Andrew is maintainer of misc. stuff.
