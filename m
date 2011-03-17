Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1CQMZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:25:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40262 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1CQMZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=RAu8flQHYEgQ24xmTNYEUex/iiUBFsMO6o5PXACu3Oavie6lFbEvuR8Bjgs/yZsLzT
         K6j9eHr7wAERixLTEW4xL1tVc8utpu5NGHBAG3bDXzYKA7hFv13WlHdvRYS0RDI5Xoc8
         hIViHWmVX9HGWBVtRPmnBxrbTGWm8TJoPUCGo=
MIME-Version: 1.0
Date: Thu, 17 Mar 2011 13:25:08 +0100
Message-ID: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
Subject: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: laijs@cn.fujitsu.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com,
        rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai,

Your commit 2e12978a
(futex,plist: Pass the real head of the priority list to plist_del())
triggers gazillions warnings on User Mode Linux (x86, Linus' tree as of today):

------------[ cut here ]------------
WARNING: at kernel/futex.c:786 __unqueue_futex+0x12/0x16()
Modules linked in:
27d4cce8:  [<081c13fe>] dump_stack+0x1c/0x20
27d4cd00:  [<08071aa0>] warn_slowpath_common+0x49/0x5f
27d4cd18:  [<08071acb>] warn_slowpath_null+0x15/0x19
27d4cd28:  [<0808fdb8>] __unqueue_futex+0x12/0x16
27d4cd38:  [<0808fef3>] futex_wait+0x137/0x1ed
27d4cdd0:  [<080910c3>] do_futex+0x78/0x7c4
27d4cedc:  [<080918e6>] sys_futex+0xd7/0xed
27d4cf28:  [<0805abf6>] handle_syscall+0x7a/0x98
27d4cf78:  [<080685d9>] userspace+0x2c9/0x370
27d4cfe0:  [<08058be5>] fork_handler+0x53/0x5b
27d4cffc:  [<00000000>] 0x0

---[ end trace ed7709f235f82328 ]---

!spin_is_locked(q->lock_ptr) in the WARN_ON() at line 786
triggers the warnings.

I'm not sure whether this shows a bug within UML
or the WARN_ON() is wrong.

What do you think?

-- 
Thanks,
//richard
