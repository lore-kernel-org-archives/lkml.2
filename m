Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566Ab0HESbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:31:11 -0400
Received: from xenotime.net ([72.52.115.56]:35689 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754742Ab0HESbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:31:07 -0400
Date: Thu, 05 Aug 2010 11:23:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 1/7] aio: fix wrong subsystem comments
Message-ID: <12810325911230@xenotime.net>
In-Reply-To: 
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Hi Benjamin and aio guys,

I fixed wrong comments on the aio subsystem. Although it causes no binary
change, I confirmed the kernel applying this patch can boot on my i386 box.

Since I doesn't subscribe this list, please Cc me if you reply this mail.

Thanks,
Satoru
---
Fix wrong comments on the aio subsystem.

 - sys_io_destroy(): acutually return -EINVAL if the context pointed to
   is invalidIndex: linux-2.6.33-rc4/fs/aio.c
 - sys_io_getevents(): An argument specifying timeout is not `when',
   but `timeout'.
 - sys_io_getevents(): Should describe what is returned if this syscall
   succeeds.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/aio.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- linux-2.6.35-rc3.orig/fs/aio.c
+++ linux-2.6.35-rc3/fs/aio.c
@@ -1277,7 +1277,7 @@ out:
 /* sys_io_destroy:
  *	Destroy the aio_context specified.  May cancel any outstanding 
  *	AIOs and block on completion.  Will fail with -ENOSYS if not
- *	implemented.  May fail with -EFAULT if the context pointed to
+ *	implemented.  May fail with -EINVAL if the context pointed to
  *	is invalid.
  */
 SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
@@ -1795,15 +1795,16 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 
 /* io_getevents:
  *	Attempts to read at least min_nr events and up to nr events from
- *	the completion queue for the aio_context specified by ctx_id.  May
- *	fail with -EINVAL if ctx_id is invalid, if min_nr is out of range,
- *	if nr is out of range, if when is out of range.  May fail with
- *	-EFAULT if any of the memory specified to is invalid.  May return
- *	0 or < min_nr if no events are available and the timeout specified
- *	by when	has elapsed, where when == NULL specifies an infinite
- *	timeout.  Note that the timeout pointed to by when is relative and
- *	will be updated if not NULL and the operation blocks.  Will fail
- *	with -ENOSYS if not implemented.
+ *	the completion queue for the aio_context specified by ctx_id. If
+ *	it succeeds, the number of read events is returned. May fail with
+ *	-EINVAL if ctx_id is invalid, if min_nr is out of range, if nr is
+ *	out of range, if timeout is out of range.  May fail with -EFAULT
+ *	if any of the memory specified is invalid.  May return 0 or
+ *	< min_nr if the timeout specified by timeout has elapsed
+ *	before sufficient events are available, where timeout == NULL
+ *	specifies an infinite timeout. Note that the timeout pointed to by
+ *	timeout is relative and will be updated if not NULL and the
+ *	operation blocks. Will fail with -ENOSYS if not implemented.
  */
 SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		long, min_nr,


-- 

