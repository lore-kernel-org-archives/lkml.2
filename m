Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2B2UQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:16:30 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45846 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752953Ab2B2UQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:16:28 -0500
Message-ID: <1330546587.22627.7.camel@joe2Laptop>
Subject: Re: [PATCH] get_maintainer.pl: Add support for moderated lists
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, Ian.Campbell@citrix.com, florian@mickler.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 12:16:27 -0800
In-Reply-To: <4F4E8555.5040002@nod.at>
References: <1330544962-995-1-git-send-email-richard@nod.at>
	 <1330545526.22465.5.camel@joe2Laptop> <4F4E8555.5040002@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 21:06 +0100, Richard Weinberger wrote:
> Joe,
> 
> Am 29.02.2012 20:58, schrieb Joe Perches:
> > <shrug>  From my perspective, it's correct and simple.
> > 
> > Moderated lists just means your email may get delayed
> > and you may get a "delayed due to moderation" email.
> 
> Most moderated lists are "moderated" by nobody and the patch
> goes to /dev/null.
> 
> > It's not a big deal to me though if Andrew wants to pick
> > this up.  It seems that all current lists are marked
> > the same way.  You might consider using a case insensitive
> > m/\(moderated/i though in case some list has moderated
> > in the email address itself.
> 
> Let's keep the regular expressions as simple as possible.

No, let's make the expressions as specific as possible.
The expression change is trivial and wouldn't have much
effect on a 25Mhz 386.

> get_maintainer.pl is already damn slow enough.

It's pretty darn fast if you don't use --git
or --git-fallback.  --git is the thing that's slow.

On my slow netbook:

$ time ./scripts/get_maintainer.pl --nogit --nogit-fallback -f drivers/net/ethernet/intel/e1000e/mac.c
Jeff Kirsher <jeffrey.t.kirsher@intel.com> (supporter:INTEL ETHERNET DR...)
Jesse Brandeburg <jesse.brandeburg@intel.com> (supporter:INTEL ETHERNET DR...)
Bruce Allan <bruce.w.allan@intel.com> (supporter:INTEL ETHERNET DR...)
Carolyn Wyborny <carolyn.wyborny@intel.com> (supporter:INTEL ETHERNET DR...)
Don Skidmore <donald.c.skidmore@intel.com> (supporter:INTEL ETHERNET DR...)
Greg Rose <gregory.v.rose@intel.com> (supporter:INTEL ETHERNET DR...)
Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com> (supporter:INTEL ETHERNET DR...)
Alex Duyck <alexander.h.duyck@intel.com> (supporter:INTEL ETHERNET DR...)
John Ronciak <john.ronciak@intel.com> (supporter:INTEL ETHERNET DR...)
e1000-devel@lists.sourceforge.net (open list:INTEL ETHERNET DR...)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

real	0m0.716s
user	0m0.512s
sys	0m0.016s

An old desktop:
$ time ./scripts/get_maintainer.pl --nogit --nogit-fallback -f drivers/net/ethernet/intel/e1000e/mac.c
Jeff Kirsher <jeffrey.t.kirsher@intel.com> (supporter:INTEL ETHERNET DR...)
Jesse Brandeburg <jesse.brandeburg@intel.com> (supporter:INTEL ETHERNET DR...)
Bruce Allan <bruce.w.allan@intel.com> (supporter:INTEL ETHERNET DR...)
Carolyn Wyborny <carolyn.wyborny@intel.com> (supporter:INTEL ETHERNET DR...)
Don Skidmore <donald.c.skidmore@intel.com> (supporter:INTEL ETHERNET DR...)
Greg Rose <gregory.v.rose@intel.com> (supporter:INTEL ETHERNET DR...)
Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com> (supporter:INTEL ETHERNET DR...)
Alex Duyck <alexander.h.duyck@intel.com> (supporter:INTEL ETHERNET DR...)
John Ronciak <john.ronciak@intel.com> (supporter:INTEL ETHERNET DR...)
e1000-devel@lists.sourceforge.net (open list:INTEL ETHERNET DR...)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

real	0m0.250s
user	0m0.128s
sys	0m0.024s

Using git on the desktop (linux-next)
$ time ./scripts/get_maintainer.pl -f drivers/net/ethernet/intel/e1000e/mac.c
Jeff Kirsher <jeffrey.t.kirsher@intel.com> (supporter:INTEL ETHERNET DR...,commit_signer:17/19=89%)
Jesse Brandeburg <jesse.brandeburg@intel.com> (supporter:INTEL ETHERNET DR...)
Bruce Allan <bruce.w.allan@intel.com> (supporter:INTEL ETHERNET DR...,commit_signer:15/19=79%)
Carolyn Wyborny <carolyn.wyborny@intel.com> (supporter:INTEL ETHERNET DR...)
Don Skidmore <donald.c.skidmore@intel.com> (supporter:INTEL ETHERNET DR...)
Greg Rose <gregory.v.rose@intel.com> (supporter:INTEL ETHERNET DR...)
Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com> (supporter:INTEL ETHERNET DR...)
Alex Duyck <alexander.h.duyck@intel.com> (supporter:INTEL ETHERNET DR...)
John Ronciak <john.ronciak@intel.com> (supporter:INTEL ETHERNET DR...)
"David S. Miller" <davem@davemloft.net> (commit_signer:2/19=11%)
Tobias Klauser <tklauser@distanz.ch> (commit_signer:1/19=5%)
Jon Mason <jdmason@kudzu.us> (commit_signer:1/19=5%)
e1000-devel@lists.sourceforge.net (open list:INTEL ETHERNET DR...)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

real	0m13.357s
user	0m9.649s
sys	0m0.388s


