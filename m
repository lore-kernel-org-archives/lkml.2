Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab2LLGbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:31:07 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48165 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2LLGbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:31:05 -0500
X-Greylist: delayed 2846 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2012 01:31:05 EST
Date: Tue, 11 Dec 2012 20:47:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Benedikt Spranger <b.spranger@linutronix.de>, linux-kernel@vger.kernel.org,
        Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 1/2] uio: add warning to documentation
Message-ID: <20121212044753.GC7224@kroah.com>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
 <1355267523-19724-2-git-send-email-b.spranger@linutronix.de>
 <20121211231816.GA23621@kroah.com>
 <20121212015647.GB2642@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212015647.GB2642@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 02:56:47AM +0100, Hans J. Koch wrote:
> On Tue, Dec 11, 2012 at 03:18:16PM -0800, Greg KH wrote:
> > On Wed, Dec 12, 2012 at 12:12:01AM +0100, Benedikt Spranger wrote:
> > > The documentation has no clear statement to the POSIX 1003.1 mmap()
> > > feature, wich allows open(), mmap(), close() while the mmaped pointer is valid.
> > > The release() hook inveigled driver programmer to activate owermanagement
> > > functuonality in the release hook. This may harm.
> > > 
> > > Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> > > ---
> > >  Documentation/DocBook/uio-howto.tmpl |    7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> > > index ac3d001..59a886d 100644
> > > --- a/Documentation/DocBook/uio-howto.tmpl
> > > +++ b/Documentation/DocBook/uio-howto.tmpl
> > > @@ -499,8 +499,13 @@ device is actually used.
> > >  <listitem><para>
> > >  <varname>int (*release)(struct uio_info *info, struct inode *inode)
> > >  </varname>: Optional. If you define your own
> > > -<function>open()</function>, you will probably also want a custom
> > > +<function>release()</function>, you will probably also want a custom
> > >  <function>release()</function> function.
> > 
> > That sentance no longer makes sense.
> > 
> > > +</para><para>CAVE: The release hook may be processed, even if a mmap is aktive.
> > 
> > Huh?
> 
> I think that's right. You can successfully close() a device while userspace is still
> using a mapping. If the driver doesn't prevent it, userspace will fail with a SIGBUS
> when accessing the mapping the next time.

I understand mmap(), I was referring to the language of the wording :)

thanks,

greg k-h
