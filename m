Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2AaLFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:05:33 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:22703 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752804Ab2AaLFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:05:31 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYNTH0-02-3SG-02
X-M-MSG: 
Date: Tue, 31 Jan 2012 12:05:22 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Michal Marek <mmarek@suse.cz>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH] kbuild: Fix link to headers in 'make deb-pkg'
Message-ID: <20120131110522.GA2191@amd.com>
References: <1327318828-12984-1-git-send-email-joerg.roedel@amd.com>
 <4F1D8810.1040501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F1D8810.1040501@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

any news on this?

On Mon, Jan 23, 2012 at 05:17:20PM +0100, Michal Marek wrote:
> (adding max to CC)
> 
> On 23.1.2012 12:40, Joerg Roedel wrote:
> > The Link to the kernel header files in the debian packages
> > point to the original build directory. This is a bad choice
> > if the packages were installed on a different machine. Fix
> > this in by manually re-creating the link in the builddeb
> > script.
> > With this patch applied the lib/modules/$version dir always
> > exists, so move the "$ARCH = um" check out of the modules
> > check too.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  scripts/package/builddeb |   13 +++++++++----
> >  1 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> > index f6cbc3d..46f63dc 100644
> > --- a/scripts/package/builddeb
> > +++ b/scripts/package/builddeb
> > @@ -91,6 +91,7 @@ fi
> >  rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir"
> >  mkdir -m 755 -p "$tmpdir/DEBIAN"
> >  mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
> > +mkdir -p  "$tmpdir/lib/modules/$version"
> >  mkdir -m 755 -p "$fwdir/DEBIAN"
> >  mkdir -p "$fwdir/lib" "$fwdir/usr/share/doc/$fwpackagename"
> >  mkdir -m 755 -p "$libc_headers_dir/DEBIAN"
> > @@ -121,10 +122,14 @@ fi
> >  
> >  if grep -q '^CONFIG_MODULES=y' .config ; then
> >  	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
> > -	if [ "$ARCH" = "um" ] ; then
> > -		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
> > -		rmdir "$tmpdir/lib/modules/$version"
> > -	fi
> > +fi
> > +
> > +# Make sure link to the headers is correct
> > +ln -snf "/usr/src/$kernel_headers_packagename" "$tmpdir/lib/modules/$version/build"
> > +
> > +if [ "$ARCH" = "um" ] ; then
> > +	mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
> > +	rmdir "$tmpdir/lib/modules/$version"
> >  fi
> >  
> >  make headers_check
> 

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

