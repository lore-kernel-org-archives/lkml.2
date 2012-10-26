Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab2JZPRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:17:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab2JZPRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:17:05 -0400
Date: Fri, 26 Oct 2012 11:16:36 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121026151636.GA1578@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	linux-kernel@vger.kernel.org
References: <20121017034918.GA13295@redhat.com>
 <20121024164235.GA2467@swordfish>
 <20121024180608.GA22840@redhat.com>
 <20121024182111.GA2340@swordfish>
 <CAFTL4hxmh7yV8ePUhY_7hOuG=JrbZZcNvV88bWcUmwG9X0W04A@mail.gmail.com>
 <20121025055056.GA2661@swordfish>
 <CAFTL4hxM8KqL3=GLkJDU-9pKVHrb1nSoDgFx8UVB7F7tryw6HA@mail.gmail.com>
 <20121025074147.GA2240@swordfish>
 <CAFTL4hw=orRVYzuk8L1aBHCxVD05uT_fdFoRJ_BkihoNd0huJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hw=orRVYzuk8L1aBHCxVD05uT_fdFoRJ_BkihoNd0huJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:44:11AM +0200, Frederic Weisbecker wrote:
 > 2012/10/25 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>:
 > > On (10/25/12 09:06), Frederic Weisbecker wrote:
 > >> >> > My understanding is (I may be wrong) that we can schedule() from ptrace chain to
 > >> >> > some arbitrary task, which will continue its execution from the point where RCU assumes
 > >> >> > CPU as not idle, while CPU in fact still in idle state -- no one said rcu_idle_exit()
 > >> >> > (or similar) prior to schedule() call.
 > >> >>
 > >> >> Yeah but when we are in syscall_trace_leave(), the CPU shouldn't be in
 > >> >> RCU idle mode. That's where the bug is. How do you manage to trigger
 > >> >> this bug?
 > >> >
 > >> > strace -f <anything>
 > >> I can't reproduce. Can you send me your config?
 > >
 > > sure, attached.
 > 
 > Thanks.
 > 
 > Sergey, Dave,
 > 
 > Does the patch I just sent you fix the issue?

I only saw this happening after hours of fuzzing.
Right now I keep running into other issues before that gets a chance to happen,
so I've not seen it in a while.

I'll apply it to my tree, and run with it though.

If I see it again, you'll be first to know :)

	Dave

