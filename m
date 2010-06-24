Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0FXRCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:02:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49231 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab0FXRCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:02:43 -0400
Date: Thu, 24 Jun 2010 10:02:40 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] security: Yama LSM
Message-ID: <20100624170240.GE4809@outflux.net>
References: <20100623182054.GN5876@outflux.net>
 <20100624002859.GA4841@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624002859.GA4841@hallyn.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 07:28:59PM -0500, Serge E. Hallyn wrote:
> > +==============================================================
> > diff --git a/fs/exec.c b/fs/exec.c
> > index e19de6a..85092e3 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -55,6 +55,7 @@
> >  #include <linux/fsnotify.h>
> >  #include <linux/fs_struct.h>
> >  #include <linux/pipe_fs_i.h>
> > +#include <linux/ctype.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/mmu_context.h>
> 
> Can you explain the fs/exec.c hunk?

Argh.  This is a mis-rebase when I was working on the get_task_comm patch.
This belongs there.  I will resend both.

> > +		while (walker->pid > 0) {
> > +			if (walker == current)
> > +				break;
> > +			walker = walker->real_parent;
> > +		}
> > +		if (walker->pid == 0)
> > +			rc = -EPERM;
> 
> Don't recall whether I ended up sending the email addressing this
> last time, but task->pid is the global pid, so pid==0 does mean
> what you think it does regardless of pid namespaces.

Okay, good, thanks.

> > +	/* owner and follower match? */
> > +	cred = current_cred();
> > +	inode = dentry->d_inode;
> > +	if (cred->fsuid == inode->i_uid)
> > +		return 0;
> 
> This'll need user-namespace luvin' at some point, but that's my problem,
> not yours.

That's going to be quite a patch.  :)  I'm looking forward to it!

-Kees

-- 
Kees Cook
Ubuntu Security Team
