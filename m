Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2FXGfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 02:35:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42772 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888Ab2FXGfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 02:35:20 -0400
X-Sasl-enc: i3XPxXf5NPtZBI8WobjnZaHmlB1pDBieRcgZ5Pc2qZ4s 1340519719
Date: Sat, 23 Jun 2012 23:35:18 -0700
From: Greg KH <greg@kroah.com>
To: iseletsk@cloudlinux.com
Cc: fa.linux.kernel@googlegroups.com, Alex Lyashkov <umka@cloudlinux.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH] Taint kernel when lve module is loaded
Message-ID: <20120624063518.GA11266@kroah.com>
References: <fa.WTHIDfGYg3w7zn9rxlDshNfnPtI@ifi.uio.no>
 <fa.lxvUw3/2JBxq1zvQzI4sJk8pEOQ@ifi.uio.no>
 <fa.Fdbx7aeDSXKMF/2ajG0IUf0AAKs@ifi.uio.no>
 <fa.TAjdtaR/BMl+PZAWwtAit9BevAo@ifi.uio.no>
 <fa.cm6Pl6ITE2qRnrdz/DXqaOSgExs@ifi.uio.no>
 <8dc680a1-4a03-462d-b381-bf5c1470aa7e@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dc680a1-4a03-462d-b381-bf5c1470aa7e@googlegroups.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 12:26:41PM -0700, iseletsk@cloudlinux.com wrote:
> On Friday, June 22, 2012 3:43:23 PM UTC-4, Greg KH wrote:
> > On Fri, Jun 22, 2012 at 12:22:22PM -0700, Greg KH wrote:
> > > On Fri, Jun 22, 2012 at 07:51:42PM +0100, Matthew Garrett wrote:
> > > > On Fri, Jun 22, 2012 at 11:43:59AM -0700, Greg KH wrote:
> > > > 
> > > > > Do you have a pointer to this code anywhere?  Lying about the license to
> > > > > the kernel is a pretty blatent thing to do and I'd like to have some
> > > > > people follow up on that issue.
> > > > 
> > > > http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/x86_64/RPMS/kmod-lve-2.6.18-408.el5.lve1.1.64.2-1.1-10.7.3.el5.x86_64.rpm 
> > > > - there's no corresponding SRPM in 
> > > > http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/SRPMS/ and 
> > > > upstream apparently refuse to provide source. Alex Lyashkov (Cc:ed) is 
> > > > listed as module author in the metadata.
> > > 
> > > Hm, and at least one reason it needs to be GPL is due to it using
> > > symbols I created, no fun.
> > > 
> > > Alex, can you please provide the source code for this module?  Or is the
> > > license that the code is saying it is, somehow incorrect?  If so, can
> > > you please fix it?  If you can't do this, is there someone else I should
> > > be contacting?
> > 
> > Also, I almost hate to ask this, but why in the world are you creating
> > sysfs binary files?  I really don't think you should be doing this, as
> > those are only for firmware and other "pass-through" things the kernel
> > uses to have userspace talk directly to hardware.
> > 
> > Odds are you can remove these files, and use the "correct" user/kernel
> > interface which will result in much better speed and handle things
> > properly for you, instead of abusing this interface.
> > 
> > Unless you really are talking directly to hardware, in which case, I'm
> > kind of interested to see what you are doing here, so the source code
> > would be greatly appreciated.
> > 
> > thanks,
> > 
> > greg k-h
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Greg,
> 
> We do a "hack", which is not a pretty one, populating /sys with
> .htaccess files. This is really needed only by shared hosters, where
> one of the end users on the server, could be a hacker and could create
> symlinks that would later be followed by apache to read privileged
> information.

I don't understand how adding a .htaccess file would solve anything
here.  Are you also adding a .htaccess file to every directory in the
whole system?

> A better fix would be fixing the apache. Yet, surprisingly enough --
> we control kernel on those servers -- but we don't control apache. So
> -- we tried to secure things for our customers in this particular way.
> Most likely we will through it out anyway.

As it's probably not solving anything real, please don't do that :)

greg k-h
