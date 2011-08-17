Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1HQVnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:43:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57387 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1HQVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:42:59 -0400
Subject: Re: pstore: change mutex locking to spin_locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110817142225.8645fff7.akpm@linux-foundation.org>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
	 <20110817142225.8645fff7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 23:47:59 +0200
Message-ID: <1313617679.2212.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 14:22 -0700, Andrew Morton wrote:
> It's still bad if lockdep is enabled.  See
> kernel/lockdep.c:lock_acquire() and lock_release().  They aren't
> NMI-safe. 

Good thing nmi_enter() does lockdep_disable() and makes lock_acquire()
bail on if (current->lockdep_recursion).

Still the fact that pstore needs locks from NMI context (let alone tried
to use a mutex) makes one think one should avoid it like the plague.

