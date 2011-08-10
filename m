Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HJQ3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:29:08 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:47793 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1HJQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:29:06 -0400
X-IronPort-AV: E=Sophos;i="4.67,351,1309737600"; 
   d="scan'208";a="7216218"
Subject: [PATCH 0/2 v2] minor cleanups to EFLAGS initialisation in
 ret_from_fork
From: Ian Campbell <Ian.Campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        LinusTorvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Aug 2011 17:29:03 +0100
Message-ID: <1312993743.26263.268.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series removes the use of a global kernel_eflags variable
from the x86_64 ret_from_fork path and (very slightly) merges the 32 and
64 bit version of that code path.

kernel_eflags could be made a __read_mostly but actually there is no
reason to prefer the value at cpu_init() time to a compile time constant
value for the initial eflags after a fork.

Test booted on 32 and 64 bit.

changes since v1:
      * rebased onto tip/master
      * make 32 bit look like 64 bit instead of vice versa since the
        behaviour of resetting eflags with interrupts disabled before
        calling schedule_tail seems more obviously safe than resetting
        eflags with interrupts enabled afterwards (although I think both
        are actually correct).
      * As a consequence of the above patch 3/3 (use symbolic names for
        bits in eflags) goes away since we only use the MBO bit 1 now,
        which doesn't have a name.

