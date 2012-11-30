Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579Ab2K3PHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:07:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030560Ab2K3PHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:07:14 -0500
Date: Fri, 30 Nov 2012 10:07:05 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cifs: Enable Kconfig control of CIFS_DEBUG
Message-ID: <20121130100705.782980df@tlielax.poochiereds.net>
In-Reply-To: <1354287460.11903.8.camel@joe-AO722>
References: <cover.1354217746.git.joe@perches.com>
	<5f5c9196b44908026a27333ef31dd4ebf4314de2.1354217746.git.joe@perches.com>
	<20121130065629.52c489dc@tlielax.poochiereds.net>
	<1354287460.11903.8.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 06:57:40 -0800
Joe Perches <joe@perches.com> wrote:

> On Fri, 2012-11-30 at 06:56 -0500, Jeff Layton wrote:
> > On Thu, 29 Nov 2012 11:37:20 -0800
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > Rather than havign a permanently enabled #define, allow
> > > control over it.
> > > 
> > > This can reduce the size of the module by ~100KB which
> > > could be useful for embedded systems.
> []
> > > diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> > > index 4d12fe4..6867a7f 100644
> > > --- a/fs/cifs/cifs_debug.h
> > > +++ b/fs/cifs/cifs_debug.h
> > > @@ -18,7 +18,10 @@
> > >   *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> > >   *
> > >  */
> > > -#define CIFS_DEBUG		/* BB temporary */
> > > +
> > > +#ifdef CONFIG_CIFS_DEBUG
> > > +#define CIFS_DEBUG
> > > +#endif
> > >  
> > >  #ifndef _H_CIFS_DEBUG
> > >  #define _H_CIFS_DEBUG
> > 
> > Looks fine, but I'd probably prefer to just get rid of CIFS_DEBUG
> > altogether here and replace it with CONFIG_CIFS_DEBUG.
> 
> I wasn't sure if there was other code anywhere else that depends
> on CIFS_DEBUG.  There isn't any in the kernel source tree.  If not,
> then you are right, it should be just CONFIG_CIFS_DEBUG.
> 

There shouldn't be. None of this stuff is exposed to userspace, AFAIK.
I think it's ok to just make that CONFIG_CIFS_DEBUG.

> > While you're at it, /proc/fs/cifs/cifsFYI should probably not be
> > present when CONFIG_CIFS_DEBUG isn't set. Perhaps we should also
> > disable traceSMB and its related functions too in that case?
> 
> That could be considered a kernel api change.
> If people agree to delete it, I'd be OK with it.
> 

If you compile with CONFIG_CIFS_DEBUG turned off, then the cifsFYI file
will be a knob that's not hooked up to anything. I think it's best not
to present it at all in that case.

traceSMB is a little harder to make the case for. Theoretically, it'll
still work after your changes, but I'm not sure it makes sense to leave
that knob around since it's technically a flag for debugging. You're
probably fine not to worry about that one. I'll look at that at some
point in the future.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
