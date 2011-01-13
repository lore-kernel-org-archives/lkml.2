Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab1AMWqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:46:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1AMWqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:46:14 -0500
Date: Thu, 13 Jan 2011 14:41:43 -0800
From: Greg KH <gregkh@suse.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Add missing format attribute specifications
Message-ID: <20110113224143.GA14885@suse.de>
References: <201101011351.52691.bvanassche@acm.org>
 <201101132152.11721.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101132152.11721.bvanassche@acm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 09:52:11PM +0100, Bart Van Assche wrote:
> On Saturday 01 January 2011 13:51:52 Bart Van Assche wrote:
> > Several functions in <linux/kobject.h> accept printf-style arguments.
> > Some of these functions have been annotated with a format attribute
> > declaration while others have not been annotated. Add a format attribute
> > specification where it is missing.
> > 
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
> > 
> > ---
> >  include/linux/kobject.h |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> > index 8f6d121..15e82c1 100644
> > --- a/include/linux/kobject.h
> > +++ b/include/linux/kobject.h
> > @@ -85,11 +85,13 @@ static inline const char *kobject_name(const struct kobject *kobj)
> >  extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
> >  extern int __must_check kobject_add(struct kobject *kobj,
> >  				    struct kobject *parent,
> > -				    const char *fmt, ...);
> > +				    const char *fmt, ...)
> > +	__attribute__((format(printf, 3, 4)));
> >  extern int __must_check kobject_init_and_add(struct kobject *kobj,
> >  					     struct kobj_type *ktype,
> >  					     struct kobject *parent,
> > -					     const char *fmt, ...);
> > +					     const char *fmt, ...)
> > +	__attribute__((format(printf, 4, 5)));
> >  
> >  extern void kobject_del(struct kobject *kobj);
> >  
> > @@ -226,6 +228,7 @@ static inline int kobject_uevent_env(struct kobject *kobj,
> >  
> >  static inline int add_uevent_var(struct kobj_uevent_env *env,
> >  				 const char *format, ...)
> > +	__attribute__((format(printf, 2, 3)))
> >  { return 0; }
> >  
> >  static inline int kobject_action_type(const char *buf, size_t count,
> 
> Hello Greg,
> 
> Have you already had the time to have a look at this patch and the two
> patches that can be found here: http://lkml.org/lkml/2010/12/21/97 ?

It's in my "to-apply" queue that I will be getting to once .38-rc1 is
out.  Sorry, but I was gone for a few weeks at the end of last year.

thanks for your patience,

greg k-h
