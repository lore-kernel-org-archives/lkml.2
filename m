Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1CWQYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:24:04 -0400
Received: from kroah.org ([198.145.64.141]:33780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1CWQYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:24:02 -0400
Date: Wed, 23 Mar 2011 09:23:51 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of
 existing in kernel equivalents.
Message-ID: <20110323162351.GB9367@kroah.com>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
 <1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
 <AANLkTimeEKjVwwYi+twb0oeoFK-33LMx5aQBZEnPodne@mail.gmail.com>
 <20110323160120.GA8770@kroah.com>
 <4D8A1CB7.4090505@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8A1CB7.4090505@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 04:15:51PM +0000, Jonathan Cameron wrote:
> On 03/23/11 16:01, Greg KH wrote:
> > On Wed, Mar 23, 2011 at 05:30:11PM +0200, Alexey Dobriyan wrote:
> >> On Wed, Mar 23, 2011 at 3:39 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> >>> +int kstrtobool(const char *s, bool *res)
> >>> +{
> >>> +       switch (s[0]) {
> >>> +       case 'y':
> >>> +       case 'Y':
> >>> +       case '1':
> >>> +               *res = true;
> >>> +       case 'n':
> >>> +       case 'N':
> >>> +       case '0':
> >>> +               *res = false;
> >>> +       default:
> >>> +               return -EINVAL;
> >>> +       }
> >>> +       return 0;
> >>> +}
> >>
> >> sigh... such simple thing and so many bugs
> Yeah, not by best work.
> >>
> >> The only values such function should accept is 0 and 1.
> > 
> > Why?  That's not the way the existing kernel functions that use this
> > work.
> > 
> >> Have you read the rest of kstrto*() code?
> >> Where is newline check?
> There are plenty of nastier cases that get through than a newline
> in the middle of the string (ybobsyouruncle -> 1 nyes->0 :)
> >>
> >> Anyway, I think it's better do not exist.
> > 
> > I think it is, as it's already duplicated in at least 2 different places
> > in the kernel, and probably more.  Once we get this implementation
> > working correctly, we don't need to rewrite it again.
> Perhaps naming it like this is a bad idea.  It manages to imply that it
> has the same level of strict checking which is seen in the other kstrto*
> functions - which is self evidently not true!

Ok, perhaps the name might need to be changed a bit, but the idea is
still good to have.  Please try again.

thanks,

greg k-h
