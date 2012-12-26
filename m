Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab2LZXbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 18:31:47 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39012 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2LZXbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 18:31:45 -0500
Date: Wed, 26 Dec 2012 15:31:41 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Zach Brown <zab@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/26] aio: remove retry-based AIO
Message-ID: <20121226233141.GC20185@google.com>
References: <CAJd=RBBAcZXKZZSrMuzm963ie81oGjHzYgyogtr2SPW2E0E_0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBAcZXKZZSrMuzm963ie81oGjHzYgyogtr2SPW2E0E_0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 08:04:11PM +0800, Hillf Danton wrote:
> >@@ -52,15 +46,6 @@ struct kioctx;
> >  * not ask the method again -- ki_retry must ensure forward progress.
> >  * aio_complete() must be called once and only once in the future, multiple
> >  * calls may result in undefined behaviour.
> >- *
> >- * If ki_retry returns -EIOCBRETRY it has made a promise that kick_iocb()
> >- * will be called on the kiocb pointer in the future.  This may happen
> >- * through generic helpers that associate kiocb->ki_wait with a wait
> >- * queue head that ki_retry uses via current->io_wait.  It can also happen
> >- * with custom tracking and manual calls to kick_iocb(), though that is
> >- * discouraged.  In either case, kick_iocb() must be called once and only
> >- * once.  ki_retry must ensure forward progress, the AIO core will wait
> >- * indefinitely for kick_iocb() to be called.
> >  */
> > struct kiocb {
> > 	struct list_head	ki_run_list;
> 
> Then you can also erase ki_run_list if no longer used.

Thanks, fixed that and also the comments you pointed out.
