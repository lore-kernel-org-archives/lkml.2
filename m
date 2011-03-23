Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab1CWQEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:04:38 -0400
Received: from kroah.org ([198.145.64.141]:41253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab1CWQEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:04:36 -0400
Date: Wed, 23 Mar 2011 09:01:20 -0700
From: Greg KH <greg@kroah.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of
 existing in kernel equivalents.
Message-ID: <20110323160120.GA8770@kroah.com>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
 <1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
 <AANLkTimeEKjVwwYi+twb0oeoFK-33LMx5aQBZEnPodne@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimeEKjVwwYi+twb0oeoFK-33LMx5aQBZEnPodne@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 05:30:11PM +0200, Alexey Dobriyan wrote:
> On Wed, Mar 23, 2011 at 3:39 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> > +int kstrtobool(const char *s, bool *res)
> > +{
> > +       switch (s[0]) {
> > +       case 'y':
> > +       case 'Y':
> > +       case '1':
> > +               *res = true;
> > +       case 'n':
> > +       case 'N':
> > +       case '0':
> > +               *res = false;
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +       return 0;
> > +}
> 
> sigh... such simple thing and so many bugs
> 
> The only values such function should accept is 0 and 1.

Why?  That's not the way the existing kernel functions that use this
work.

> Have you read the rest of kstrto*() code?
> Where is newline check?
> 
> Anyway, I think it's better do not exist.

I think it is, as it's already duplicated in at least 2 different places
in the kernel, and probably more.  Once we get this implementation
working correctly, we don't need to rewrite it again.

thanks,

greg k-h
