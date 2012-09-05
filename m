Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2IENFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:05:32 -0400
Received: from local.xorcom.com ([81.218.177.19]:50853 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab2IENFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:05:30 -0400
Date: Wed, 5 Sep 2012 16:05:28 +0300
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: remove unneeded explicit Architecture
Message-ID: <20120905130528.GI18204@xorcom.com>
References: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
 <5040C112.70501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5040C112.70501@suse.cz>
X-Forced-Service: Sadly Using Gmail [tm]
Organization: Xorcom*
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your reply,

On Fri, Aug 31, 2012 at 03:50:10PM +0200, Michal Marek wrote:
> Adding Max to CC.
> 
> On 14.8.2012 12:44, Tzafrir Cohen wrote:
> > Architecture was set explicitly in debian/control for one of the three
> > packages (linux-libc-dev) but not for the other two. When cross-building
> > it gives me an error:
> > 
> >   dpkg-gencontrol: error: current host architecture 'armhf' does not
> >   appear in package's architecture list (amd64)
> > 
> > Also note that if used, dpkg --print-architecture should have been
> > replaced with dpkg-architecture.
> > 
> > Signed-off-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
> > ---
> >  scripts/package/builddeb |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> > index acb8650..d9c71a6 100644
> > --- a/scripts/package/builddeb
> > +++ b/scripts/package/builddeb
> > @@ -252,13 +252,12 @@ mkdir -p "$destdir"
> >  (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
> >  ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
> >  rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
> > -arch=$(dpkg --print-architecture)
> >  
> >  cat <<EOF >> debian/control
> >  
> >  Package: $kernel_headers_packagename
> >  Provides: linux-headers, linux-headers-2.6
> > -Architecture: $arch
> > +Architecture: any
> >  Description: Linux kernel headers for $KERNELRELEASE on $arch
> >   This package provides kernel header files for $KERNELRELEASE on $arch
> >   .
> 
> As the package contains files from arch/$SRCARCH/include, I doubt that
> this is a valid change.

But you optionally force the Architecture later on in build_package.
"Arhcitecture: any" in the source package states that the binary package
will be the one stated by the build system.

-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
