Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2FGANw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab2FGANv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:13:51 -0400
Date: Wed, 6 Jun 2012 20:13:40 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>, mingo@kernel.org
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607001340.GA22223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mingo@kernel.org
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120604000059.GA14144@redhat.com>
 <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
 <1338802157.28282.7.camel@twins>
 <1338806988.28282.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338806988.28282.17.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 12:49:48PM +0200, Peter Zijlstra wrote:

 > Something like the compile tested only patch below should do both
 > things.
 > 
 ..
 > +#ifdef CONFIG_LOCK_STAT
 > +
 > +static void lockstat_contended(struct held_lock *hlock)
 > +{
 > +	int contention_point, contending_point;
 > +	struct lock_class_stats *stats;
 > +
 > +	hlock->waittime_stamp = lockstat_clock();
 > +
 > +	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
 > +	contending_point = lock_point(hlock_class(hlock)->contending_point,
 > +				      lock->ip);
 > +
 > +	stats = get_lock_stats(hlock_class(hlock));
 > +	if (contention_point < LOCKSTAT_POINTS)
 > +		stats->contention_point[contention_point]++;
 > +	if (contending_point < LOCKSTAT_POINTS)
 > +		stats->contending_point[contending_point]++;
 > +	if (lock->cpu != smp_processor_id())
 > +		stats->bounces[bounce_contended + !!hlock->read]++;
 > +	put_lock_stats(stats);
 > +}


kernel/lockdep.c: In function ‘lockstat_contended’:
kernel/lockdep.c:3662:70: error: ‘ip’ undeclared (first use in this function)
kernel/lockdep.c:3662:70: note: each undeclared identifier is reported only once for each function it appears in
kernel/lockdep.c:3664:11: error: ‘lock’ undeclared (first use in this function)
kernel/lockdep.c: In function ‘lockstat_acquired’:
kernel/lockdep.c:3702:13: error: ‘ip’ undeclared (first use in this function)


	Dave
