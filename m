Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2HRODB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 10:03:01 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62702 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2HROC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 10:02:58 -0400
Date: Sat, 18 Aug 2012 16:02:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Status of adaptive tickless patchset as of august 2012
Message-ID: <20120818140248.GA16073@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I started working on the adaptive nohz patchset by the end of 2010. Since then, I
iterated through one big branch:

- Nohz tasks (https://lwn.net/Articles/420490/)
- Nohz cpusets (https://lwn.net/Articles/455044/)
- Nohz cpusets v2 (https://lwn.net/Articles/487599/)
- Nohz cpusets v3 (https://lwn.net/Articles/495422/)

It quickly grew up to more than 40 patches. And still the full support
(ie: handle everything that the tick maintains, but without the tick) wasn't
yet finished.

And the more I was progressing to get this full support, the more I had patches to
maintain, rebase, improve, etc...

Some side effects went to increase:

- I had deep reviews about the core overall design in the first iterations. Thanks
to that I made nice progresses. But as the patchset grew, I got less reviews about
overall design but more about details. And I can totally understand that. Huge pile
of patches certainly don't encourage reviews.

- Lacking reviews on the overall design, I was feeling more and more uncomfortable about
whatever I was improving or whichever feature I was adding on top of the existing ones.
And I was indeed digging on some wrong direction for some parts.

- I was spending too much time in out-of-tree maintainance while my goal is to get this
upstream.

All in one, this big branch neither scaled in term of reviews nor development.

So I decided, after Ingo proposed me to set a tree in -tip, to cut all of the things the
tick is handling and isolate each of these into single separate topics and handle them
individually or at least iteratively, trying to push the things upstream or in a staging
tree in -tip piecewise. As long as this is carried by concerned maintainers and I can get
their insights on a regular basis. And also as long as we can iterate to some central branch
because, even if we can cut out things into individual topics, there are significant interdependencies.

I think this has been successfull so far:

- The detection of illegal RCU read side critical sections under RCU extended quiescent
state is now upstream. This even helped finding lot of bugs upstream.

- State of user as RCU extended quiescent state is currently pending in Paul's tree
in the rcu/idle branch. It's also in linux-next. This may likely go upstream or in
a staging branch in -tip for the next merge window.

- Some preparatory work to split nohz and idle logic in nohz API. It went upstream
on the last merge window.

- Proposed something to handle nohz cputime accounting: https://lwn.net/Articles/501766/
Got fundamental reviews that pointed me to rather reuse virtual based cputime accounting.

- Consolidated/cleaned up virtual based cputime accounting (last version is
https://lkml.org/lkml/2012/8/17/326 and waits for inclusion in -tip or so.)

- On top of that vtime consolidation and the RCU pending patches, propose
a generic virtual cputime accounting for archs that don't have CONFIG_VTIME_CPU_ACCOUNTING.
See http://comments.gmane.org/gmane.linux.kernel/1337690
A tickless CPU can then account cputime with that.

So the process seem to be in a better direction now. Summer holidays have naturally made it a
bit smoother and the rythm will probably stay that way until the end of ksummit/linuxcon/LPC. But
I have the feeling we are moving forward.

No schedule plans, but once I get the above topics sorted out, I'll probably work on timekeeping
handling in adaptive tickless CPUs. And then the rest...

I'll still keep maintaining the big branch in my tree. But this is now going to be rather a big draft or
laboratory, with regular rebases on what is merged upstream or in maintainers tree. It helps me to
keep a practical view of the big picture.

Thanks.
