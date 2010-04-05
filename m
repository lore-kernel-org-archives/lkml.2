Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0DEKhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 06:37:32 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50193 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0DEKh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 06:37:26 -0400
Message-ID: <4BB9BD52.6060109@dcl.info.waseda.ac.jp>
Date: Mon, 05 Apr 2010 19:37:06 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       mingo@elte.hu, paulus@samba.org, tglx@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] Separate lock events with types
References: <20100129221252.GA5052@nowhere> <1267002166-7281-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100326233259.GI7166@nowhere>
In-Reply-To: <20100326233259.GI7166@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/10 08:33, Frederic Weisbecker wrote:
 > On Wed, Feb 24, 2010 at 06:02:46PM +0900, Hitoshi Mitake wrote:
 >> Sorry for my long silence...
 >>
 >> Thanks for Frederic's great work like trace_lock_class_init(),
 >> overhead of perf lock was reduced a lot.
 >> But still there is overhead which cannot be disregarded.
 >>
 >> So I'd like to suggest that separating lock trace events into each 
types of lock.
 >> e.g.
 >> 	trace_lock_acquire() ->  spin_trace_lock_acquire(), 
rwlock_trace_lock_acquire()
 >> I think that mutex and spinlock are completely different things.
 >> And as I describe below, filtering at recording phase can reduce 
overhead of tracing.
 >>
 >> CAUTION:
 >> This patch is the proof of concept. The way this patch employes
 >> is different from one I described above. This patch adds if statement
 >> before trace_lock_*(). Implementation of separating events per types 
will be
 >> a big one, so this is an only trial edition for performance 
improvements.
 >
 >
 > Instead of having one different event for each type of locks,
 > I would rather suggest to add a "lock type" field in the (future)
 > lock_init_class class. This requires we implement event injection
 > properly before.
 >
 > So if we store the lock type in the lockdep_map, we can just dump
 > the type on lock class initialization:
 >
 > - on register_lock_class
 > - on event injection to catchup with lock that have already registered
 >

Yeah, this is a smarter way than the one I suggested.

But specifying types of locks to focuse on will require special way.
I thought that ioctl() will make this type specifying possible,
but it will not match to other events...
e.g. perf record will be required dirty change for it.

Do you have any good ideas at this point?

Thanks,
	Hitoshi
