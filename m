Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0JWBjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 21:39:49 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:47720 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276Ab0JWBjr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 21:39:47 -0400
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 21:39:46 EDT
Date: Sat, 23 Oct 2010 02:39:43 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36, make oldconfig broken
Message-ID: <20101023013943.GB20750@deepthought>
References: <201010221229.36996.gene.heskett@gmail.com> <201010221608.36754.gene.heskett@gmail.com> <4CC20011.5010809@oracle.com> <201010222054.52066.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201010222054.52066.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=0apVwtOf9NkA:10 a=8nJEP1OIZ-IA:10 a=BufejzzepJJOtNPhy6UA:9 a=Fth_D3a88TymgzM9LDMA:7 a=7hSA3D9cfsKPvoKXmo2O2ohUuKYA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 08:54:51PM -0400, Gene Heskett wrote:
> 
> It hasn't been edited since I ran it, so I'll attach it.  Maybe you can see 
> something I missed.
> 
Hi Gene,

 I don't see anything that is immediately wrong (but, it's late and
I'll be going to bed as soon as webkit has finished compiling on my
desktop, so my concentration might be lacking), but it does seem
overly complex.  I've long since given up trying to script kernel
builds, it mostly isn't necessary if you aren't creating a distro.

 I appreciate your comment about fingers - mine are mostly ok, but
prone to operating in the wrong order so that I often generate typos
such as 'teh'.  What works for me is -

1. build in ~/ : I often have current and "previous, but still
usable" systems on the same machine, and I share /home between them.
Arguably, building as a user may prevent some disastrous actions,
but backups are always useful - I remember your past comments about
using amanda so I'm sure you've already got that covered.

2. for each kernel version of interest (typically, current and next
- over time the old one drops out and a new one rolls in) :
 create a first version (untar, or untar and patch).
 I then rename it to 2.6.xx-stable or 2.6.xx-rc.

 For the patches I use
bzcat /path/to/patch-2.6.whatever.bz2 | patch -p1
(yes, send me tickets for "useless uses of cat" if you wish ;)

3. When I want to test a new -rc, or a release has come out, cd into
the tree and
 head Makefile
to confirm which (-rc) patch was last applied.
revert that: bzcat /path/to/that-patch.bz2 | patch -p1 -R
apply the new one

and then just make oldconfig and continue (or, for the first rc of a
new version, zcat /proc/config.gz >.config && make oldconfig.

 To keep track of errant fingers, you can read the commandline
before hitting <enter>, you can also run 'make modules_install' as a
user - it won't work, but it will confirm which version it is trying
to install.

 Sorry if this comes across as trying to teach you things you
already know, but the process should be simple enough to not need
scripting!  Of course, my video hardware doesn't need out-of-tree
firmware nor other drivers.  Perhaps in that situation I might try
to script it all.  From painful experience, the usual problem with
scripts is a failure to detect errors or unexpected results.  Keep
things simple if you can.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
