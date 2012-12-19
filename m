Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab2LSMJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:09:47 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:53356 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2LSMJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:09:45 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 07:09:45 EST
MIME-Version: 1.0
Date: Wed, 19 Dec 2012 20:04:11 +0800
Message-ID: <CAJd=RBBAcZXKZZSrMuzm963ie81oGjHzYgyogtr2SPW2E0E_0w@mail.gmail.com>
Subject: Re: [PATCH 04/26] aio: remove retry-based AIO
From: Hillf Danton <dhillf@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>@@ -52,15 +46,6 @@ struct kioctx;
>  * not ask the method again -- ki_retry must ensure forward progress.
>  * aio_complete() must be called once and only once in the future, multiple
>  * calls may result in undefined behaviour.
>- *
>- * If ki_retry returns -EIOCBRETRY it has made a promise that kick_iocb()
>- * will be called on the kiocb pointer in the future.  This may happen
>- * through generic helpers that associate kiocb->ki_wait with a wait
>- * queue head that ki_retry uses via current->io_wait.  It can also happen
>- * with custom tracking and manual calls to kick_iocb(), though that is
>- * discouraged.  In either case, kick_iocb() must be called once and only
>- * once.  ki_retry must ensure forward progress, the AIO core will wait
>- * indefinitely for kick_iocb() to be called.
>  */
> struct kiocb {
> 	struct list_head	ki_run_list;

Then you can also erase ki_run_list if no longer used.

Hillf
