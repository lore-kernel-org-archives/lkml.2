Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1DRXBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:01:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1DRXBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:01:04 -0400
Subject: Re: [PATCH 1/2] drm: Create and use drm_err
From: Dave Airlie <airlied@redhat.com>
To: Ian Romanick <idr@freedesktop.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <4DACC1B1.8090808@freedesktop.org>
References: <cover.1303097621.git.joe@perches.com>
	 <d70d2c8ad548f99e8d028a2fbd4c5b35609f8917.1303097621.git.joe@perches.com>
	 <4DACC1B1.8090808@freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 09:00:57 +1000
Message-ID: <1303167657.4842.40.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 15:56 -0700, Ian Romanick wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 04/17/2011 08:35 PM, Joe Perches wrote:
> > Reduce drm text size ~1% by using drm_err and
> > printf extension %pV to emit error messages.
> > 
> > Remove unused macro DRM_MEM_ERROR.
> > 
> > $ size drivers/gpu/drm/built-in.o*
> >    text	   data	    bss	    dec	    hex	filename
> >  361159	   9663	    256	 371078	  5a986	drivers/gpu/drm/built-in.o.new
> >  365416	   9663	    256	 375335	  5ba27	drivers/gpu/drm/built-in.o.old
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/gpu/drm/drm_stub.c |   21 +++++++++++++++++++++
> >  include/drm/drmP.h         |   21 +++++++--------------
> >  2 files changed, 28 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
> > index 001273d..6d7b083 100644
> > --- a/drivers/gpu/drm/drm_stub.c
> > +++ b/drivers/gpu/drm/drm_stub.c
> > @@ -62,6 +62,26 @@ struct idr drm_minors_idr;
> >  struct class *drm_class;
> >  struct proc_dir_entry *drm_proc_root;
> >  struct dentry *drm_debugfs_root;
> > +
> > +int drm_err(const char *func, const char *format, ...)
> > +{
> > +	struct va_format vaf;
> > +	va_list args;
> > +	int r;
> > +
> > +	va_start(args, format);
> > +
> > +	vaf.fmt = format;
> > +	vaf.va = &args;
> > +
> > +	r = printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
> 
> This code has ben reorganized a lot over the years, so this comment may
> be bogus.  However...
> 
> I believe that DRM_NAME is a define, and drm_stub.c is in common code.
> As a result, won't this change cause something different to get logged?

No I think we hacked that out a long time past thankfully, so its always
"drm" now.

Dave.

