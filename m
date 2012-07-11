Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab2GKP0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:26:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33874 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932826Ab2GKP0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:26:16 -0400
X-Sasl-enc: fuCk+bYuOZQtmCBrKHvaITUv5sU1k7/hYdbY01SM5xGU 1342020375
Date: Wed, 11 Jul 2012 08:26:14 -0700
From: Greg KH <greg@kroah.com>
To: Igor Seletskiy <iseletsk@cloudlinux.com>
Cc: fa.linux.kernel@googlegroups.com, Alex Lyashkov <umka@cloudlinux.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH] Taint kernel when lve module is loaded
Message-ID: <20120711152614.GA31086@kroah.com>
References: <fa.WTHIDfGYg3w7zn9rxlDshNfnPtI@ifi.uio.no>
 <fa.lxvUw3/2JBxq1zvQzI4sJk8pEOQ@ifi.uio.no>
 <fa.Fdbx7aeDSXKMF/2ajG0IUf0AAKs@ifi.uio.no>
 <fa.TAjdtaR/BMl+PZAWwtAit9BevAo@ifi.uio.no>
 <fa.cm6Pl6ITE2qRnrdz/DXqaOSgExs@ifi.uio.no>
 <8dc680a1-4a03-462d-b381-bf5c1470aa7e@googlegroups.com>
 <20120624063518.GA11266@kroah.com>
 <CA+-XxSG8mpERvUwKgG4M8=ZuSd3P+ZYfw5mL3R4zLTAYGPW3Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+-XxSG8mpERvUwKgG4M8=ZuSd3P+ZYfw5mL3R4zLTAYGPW3Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 11:19:53PM -0400, Igor Seletskiy wrote:
> Greg,
> 
> I hope you don't mind -- I will respond to few other things / other question
> that were raised in this thread one email 
> 1. Source code for RPMs is out our source RPM repositories.
> Here is one for CL6 http://repo.cloudlinux.com/cloudlinux/6.3/updates-testing/SRPMS/
> And here is one for CL5 http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/SRPMS/
> We might be missing some older versions. If someone needs them -- please, give
> exact version.

Thank you for publishing this.  Unfortunatly your source code is still
lying about the license of the kernel module to the kernel, and as such,
I'm totally confused.  The package says it is covered under the
"CloudLinux Commercial License" which you include in the
lve-kmod-1.1-9.2.4.el6.src.rpm package, yet the code says it is released
under the GPL with the following lines:
	//MODULE_LICENSE("CloudLinux Commercial License");
	/* Temporary solution to use GPL-only symbol 'put_fs_struct' */
	MODULE_LICENSE("GPL");
and then you include the GPL v3 license in the tarball as well, which
makes no sense at all as the v3 license isn't compatible with the
kernel's v2 license, as you know.

So, what is the real license for the code you have published here?

> 2. The delay was due to a few things:
> a) We released many versions of RPMs for lve-kmod -- and it was my
> understanding that to comply with GPL, I have to release a source code for each
> version.

Yes, which should come directly from the tool you used to generate those
rpms, you had to create them somehow, right?  It should be simple to
just put them on the site as well, as you do have them.

> b) I didn't know the actual size of the work involved, and I wanted to make
> sure I can deliver in time specified.

There should not be any new work, it's just posting the same source you
used to build the binaries from.

> c) We had planned several major releases & have to prepare for the HostingCon
> in mid July which is stressing resources of our company as it is.

I don't understand how that has any relvance to the delay of posting the
code you already have.

> 3. We did originally put .htaccess in pretty much every directory, but that
> didn't work well, as it broke bunch of software. Right now we are putting those
> files in all the directories that we consider as "sensitive", like:
> /etc/httpd/conf/
> /etc/valiases/
> /etc/vdomainaliases
> /etc/vfilters
> etc...
> And we give our users a way to add more directories. We know it is not perfect,
> but we were protecting against real attacks happening at the moment.
> Maybe we went overboard with trying to protect /proc & /sys -- I don't know.
> Those were not targeted yet.
> Good, long term solution would be correcting apache module. Yet, once again --
> we don't control apache, and it is hard for us to push out new modules for
> apache. It would probably take us 6 to 12 months to get it into the hands of
> all our customers.
> We do control kernel (not just kernel module) -- and could deliver some
> protection right away.

It's easier to change the kernel than a userspace package?  Something is
really wrong with that model :)

> 4. This brings us to the 3rd part. We change the kernel, and anyone using our
> module also using our kernel. It just that regular kernel wouldn't work, and we
> use slightly patched kernel from OpenVZ. 

That's fine, nothing wrong with that.

> 5. The reason we want to keep our LVE module closed source is due to the market
> we serve.

So you are saying that somehow the market drives you to violate the
license of the product you are using to serve that market?  That seems
very odd, and should have been considered before deciding to enter that
market, right?

That argument is "interesting" it sounds like you have made a business
decision to assume this risk, which is fine.  But you do fully
understand the risk involved here, right?  Hopefully your customers and
investors also understand this, as it's a pretty huge risk to them as
well.

> 6. Once again, I want to re-iterate that even though we want to keep our module
> closed source, we still want to play things right, and if we will have to
> license anything as GPL -- we will. The issue with the module was internal
> mis-communication -- that I hope is corrected.

See the above license questions for why I don't think it is corrected.
Also, I do feel you need to release your code under the GPL, as that is
what you have told the kernel it is licensed under.  Please contact your
lawyer if you have further questions about the license issues involved
here, I'm sure they will be glad to straighten this out.

thanks,

greg k-h
