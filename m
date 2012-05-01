Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab2EAAN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:13:27 -0400
Received: from ozlabs.org ([203.10.76.45]:49270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab2EAAN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:13:26 -0400
Date: Tue, 1 May 2012 10:12:38 +1000
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: get/put_online_cpus documentation wrong?
Message-ID: <20120501001238.GA15497@bloggs.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Documentation/cpu-hotplug.txt it says:

"	#include <linux/cpu.h>
	get_online_cpus() and put_online_cpus():

The above calls are used to inhibit cpu hotplug operations. While the
cpu_hotplug.refcount is non zero, the cpu_online_mask will not change.
If you merely need to avoid cpus going away, you could also use
preempt_disable() and preempt_enable() for those sections.
Just remember the critical section cannot call any
function that can sleep or schedule this process away."

That last statement doesn't seem like it can be correct, given that
get_online_cpus and put_online_cpus both do a mutex_lock(), which can
sleep.  So, is that statement still correct?  What would happen if a
process did sleep after doing get_online_cpus()?

Also, get/put_online_cpus doing mutex_lock() implies that one should
not call them in atomic context, e.g. while holding a spinlock, which
could usefully be mentioned in cpu-hotplug.txt.

I'm happy to do a patch to update cpu-hotplug.txt once it's clear what
the actual constraints are.

Paul.
