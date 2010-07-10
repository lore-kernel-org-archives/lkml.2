Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930Ab0GJRTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 13:19:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59612 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0GJRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 13:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=v98jzrMGUb8eoXGGiB5NquFBYxo8YQjTpRTMve/bZigfiysomh/q7yjaymOPxO/ejI
         zFlD3P9it5el39G3pbaxddUlY/AYT5osOLA4OJQBNg1X6+p2aCx2NxNHrjgZ0IqLp3kF
         nKRBRl40nU6huAuVpDVw+FBT806aEdm3zli9U=
MIME-Version: 1.0
In-Reply-To: <1278685800.1900.212.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	<1278685800.1900.212.camel@laptop>
Date: Sat, 10 Jul 2010 19:19:10 +0200
Message-ID: <AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/9 Peter Zijlstra <peterz@infradead.org>:
> One thing we could do, although this would make the proposed scheduler a
> wee bit more complex, is split between hard and soft realtime. Only
> accept P==rel_D for hard, and schedule the soft tasks in the hard slack
> or something like that.
>
> That way we can later extend the hard admission tests to accept more.

Sorry for jumping in a bit late. I'm not that happy with this
suggestion if I understand you correctly. The main reason for having
deadlines shorter than the periods is for tasks that need a short
response time and likely are most important for the system to be
scheduled as fast as possible. Hence if they get scheduled after the
tasks with deadline=period then that defeat the purpose with having a
short deadline. Quite often these tasks are short and hence only need
a low bandwidth, i.e. long period between activations relative to
deadline and runtime.

But also other use cases exist with longer running tasks (e.g. around
5-10 ms) per period (e.g. around 20 ms). You might have several of
such tasks running, but as a system designer you know that their
activation phase will allow them to be scheduled interleaved. This can
be for example you know that the interrupt pattern waking the tasks
are interleaved. The admission test would be even more complex if we
also need to take into account the phases of task periods. Hence I
think some of these things need to be left for the system designer
without being hindered by an admission into the highest hard deadline
scheduling policy. As you might have understood I'm mostly talking
about embedded system, which have some tasks that are central parts of
the running system but which also might in parallel run more generic
software.

Did I get your proposal correct? Do you agree that tasks that need to
set a deadline < period usually do that since they need to be
scheduled in quickly?
