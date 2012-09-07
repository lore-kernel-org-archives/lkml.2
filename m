Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2IGACi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:02:38 -0400
Received: from vostochny.stro.at ([78.47.22.85]:37285 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab2IGACf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:02:35 -0400
Date: Fri, 7 Sep 2012 02:02:09 +0200
From: maximilian attems <max@stro.at>
To: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Cc: Michal Marek <mmarek@suse.cz>, Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: remove unneeded explicit Architecture
Message-ID: <20120907000209.GA5993@stro.at>
References: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
 <5040C112.70501@suse.cz>
 <20120905130528.GI18204@xorcom.com>
 <50475310.6000508@suse.cz>
 <20120905151422.GD12713@stro.at>
 <20120905164009.GM18204@xorcom.com>
 <20120905202604.GF28778@vostochny.stro.at>
 <20120906140004.GL19848@vostochny.stro.at>
 <20120906140416.GG28778@vostochny.stro.at>
 <20120906162143.GN18204@xorcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906162143.GN18204@xorcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2012, Tzafrir Cohen wrote:
>
> Works for the case I presented.

Michal please care to queue previous v2 patch with
Tested-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
to kope with that cross building regression since
the linux headers got added to deb-pkg target.

> Now I remove the explicit setting of KBUILD_DEBRCH:

and here lies the error.
 
>   $ rm -rf debian
>   $ make ARCH=arm KBUILD_IMAGE=uImage deb-pkg
> 
>   ...
> 
>   dpkg-gencontrol: error: current host architecture 'armhf' does not
>   appear in package's architecture list (armel)
> 
> My host architecture is amd64. This is actually the build architecture.
> dpkg-gencontrol uses Dpkg::Arch::get_host_arch().
> 
>   $ perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
>   amd64
> 
>   $ CC=/usr/bin/arm-linux-gnueabi-gcc  perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
>   armel
>   
>   $ CC=/usr/bin/arm-linux-gnueabihf-gcc  perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
>   armhf
> 
>   $ DEB_HOST_ARCH=whatever perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
>   whatever
> 
> Is it OK to use that perl one-liner as the default instead of the
> architecture guessing case?

In any case that would be a follow up, but I'm not fond of that perl/dpkg
magic plus supporting DEB_ variables. I think for linux it is preferable
to have it based on UTS_MACHINE. Thus I think your testcases aren't valid,
and also you neglected the following one:
make KBUILD_DEBARCH=i386 deb-pkg # i386 userland with amd64 linux

Best.

-- 
maks
