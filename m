Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934Ab2FVMrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:47:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37783 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761543Ab2FVMrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:47:06 -0400
Message-ID: <1340369098.2464.20.camel@falcor>
Subject: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jun 2012 08:44:58 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062212-3534-0000-0000-000009A972CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

I really appreciate all of the work that has gone into making __fput()
lockless - making the syscalls use get/put_light(), signal changes, and
using Oleg's task_work_add() to defer processes. 

Currently, when unmapping a file after closing it, I'm not getting the
mmap_sem/i_mutex lockdep any more.  This seems due to Tyler Hick's
commit 978d6d8 "vfs: Correctly set the dir i_mutex lockdep class",
rather than the above changes.

Although the mmap_sem/i_mutex lockdep doesn't exist anymore, before
upstreaming IMA-appraisal, the issue with __fput() should probably be
resolved. :)   What else needs to be done to make __fput() lockless?
How can I help?

thanks,

Mimi






