Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0HHUSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 16:18:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:32776 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab0HHUSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:18:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: [BISECTED] Today's Linus.git hangs during boot: can't find the floppy
 controller
Date: Sun, 08 Aug 2010 13:17:53 -0700
Message-ID: <i3n3dh$t48$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-185-91.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b4pre) Gecko/20100808 Shredder/3.2a1pre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit produces the error:

commit 6ee0578b4daaea01c96b172c6aacca43fd9807a6
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Fri Jul 30 14:57:37 2010 -0700

     workqueue: mark init_workqueues() as early_initcall()

     Mark init_workqueues() as early_initcall() and thus it will be initialized
     before smp bringup. init_workqueues() registers for the hotcpu notifier
     and thus it should cope with the processors that are brought online after
     the workqueues are initialized.

     x86 smp bringup code uses workqueues and uses a workaround for the
     cold boot process (as the workqueues are initialized post smp_init()).
     Marking init_workqueues() as early_initcall() will pave the way for
     cleaning up this code.

     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
     Signed-off-by: Tejun Heo <tj@kernel.org>
     Cc: Oleg Nesterov <oleg@redhat.com>
     Cc: Andrew Morton <akpm@linux-foundation.org>


Just after the error message about the floppy controller not found, the
machine hangs for two minutes and then this message:

task swapper:1 blocked for greater than 120 seconds, followed by a stack
trace, and again every two minutes AFAICT.

I'm not including all the gory messages and stack traces because I'm
hoping you'll know what the problem is without them. (Fingers crossed.)

BTW, I see this problem only on my dual-core machine, not the older single
single processor machine, as I would expect from reading the commit message.
(Both machine have properly functioning floppy drives.)

I'll be happy to supply more details if needed.

Thanks

