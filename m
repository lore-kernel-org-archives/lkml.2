Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2IEPO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:14:26 -0400
Received: from vostochny.stro.at ([78.47.22.85]:41945 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2IEPOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:14:23 -0400
Date: Wed, 5 Sep 2012 17:14:22 +0200
From: maximilian attems <max@stro.at>
To: Michal Marek <mmarek@suse.cz>
Cc: Tzafrir Cohen <tzafrir.cohen@xorcom.com>,
        Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: remove unneeded explicit Architecture
Message-ID: <20120905151422.GD12713@stro.at>
References: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
 <5040C112.70501@suse.cz>
 <20120905130528.GI18204@xorcom.com>
 <50475310.6000508@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50475310.6000508@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Sep 2012, Michal Marek wrote:

> On 5.9.2012 15:05, Tzafrir Cohen wrote:
> > Hi,
> > 
> > Thanks for your reply,
> > 
> > On Fri, Aug 31, 2012 at 03:50:10PM +0200, Michal Marek wrote:
> >> Adding Max to CC.
> >>
> >> On 14.8.2012 12:44, Tzafrir Cohen wrote:
> >>> Architecture was set explicitly in debian/control for one of the three
> >>> packages (linux-libc-dev) but not for the other two. When cross-building
> >>> it gives me an error:
> >>>
> >>>   dpkg-gencontrol: error: current host architecture 'armhf' does not
> >>>   appear in package's architecture list (amd64)
> >>>
> >>> Also note that if used, dpkg --print-architecture should have been
> >>> replaced with dpkg-architecture.
> >>>
> >>> Signed-off-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
> >>> ---
> >>>  scripts/package/builddeb |    3 +--
> >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> >>> index acb8650..d9c71a6 100644
> >>> --- a/scripts/package/builddeb
> >>> +++ b/scripts/package/builddeb
> >>> @@ -252,13 +252,12 @@ mkdir -p "$destdir"
> >>>  (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
> >>>  ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
> >>>  rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
> >>> -arch=$(dpkg --print-architecture)
> >>>  
> >>>  cat <<EOF >> debian/control
> >>>  
> >>>  Package: $kernel_headers_packagename
> >>>  Provides: linux-headers, linux-headers-2.6
> >>> -Architecture: $arch
> >>> +Architecture: any
> >>>  Description: Linux kernel headers for $KERNELRELEASE on $arch
> >>>   This package provides kernel header files for $KERNELRELEASE on $arch
> >>>   .
> >>
> >> As the package contains files from arch/$SRCARCH/include, I doubt that
> >> this is a valid change.
> > 
> > But you optionally force the Architecture later on in build_package.
> > "Arhcitecture: any" in the source package states that the binary package
> > will be the one stated by the build system.
> 
> Ah, OK. I don't know much about Debian packaging in fact. Max, could you
> have a look? The original thread is here:
> http://lkml.org/lkml/2012/8/14/133. I meant to add you to CC before,
> but apparently I forgot.

yes indeed it is an invalid change.
Cross building shouldn't need it, what did you exactly try?

-- 
maks
