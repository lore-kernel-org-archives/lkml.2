Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935476Ab1ETSez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:34:55 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:59283 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934869Ab1ETSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:34:53 -0400
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        davej@redhat.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org
In-Reply-To: <20110520182705.GU25448@outflux.net>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
	 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>
	 <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan>
	 <20110520131108.GA17699@elte.hu> <1305913261.20623.12.camel@dan>
	 <BANLkTinCnqrzMyoSzS04fCAqks1bd9Y8=g@mail.gmail.com>
	 <20110520182705.GU25448@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 14:34:44 -0400
Message-ID: <1305916484.20623.23.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 11:27 -0700, Kees Cook wrote:
> On Fri, May 20, 2011 at 11:14:09AM -0700, Linus Torvalds wrote:
> > On Fri, May 20, 2011 at 10:41 AM, Dan Rosenberg
> > <drosenberg@vsecurity.com> wrote:
> > >
> > > Also, I'd still welcome suggestions on generating entropy so early in
> > > the boot process as to randomize the location at which the kernel is
> > > decompressed.
> > 
> > The fundamental problem with the whole kernel address randomization is
> > sadly totally unrelated to any of the small details.
> > 
> > There's a *big* detail that makes it hard: there's only a few bits of
> > randomness we can add to the address. The kernel base address ends up
> > having various fundamental limitations (cacheline alignment for the
> > code, and we have several segments that require page alignment), so
> > you really can't realistically do more than something like 8-12 bits
> > of address randomization.
> > 
> > Which means that once you have a vmlinux image (say, because it's a
> > standard distro kernel), you only need to try your exploit a few
> > hundred times. That can be done quickly enough that no MIS person will
> > ever have time to react to the attack.
> > 
> > Sure, it will likely leave some hints around (oopses etc), but still..
> 
> Certain flaws will present that way, yes. Others will take the entire
> system down on the first missed address guess. Many times, ASLR will
> give a statistical advantage to the defender. As a result it has value,
> even if it's not perfect.
> 

At least one distro (Red Hat) ships with panic_on_oops enabled by
default, so attackers don't get more than one chance.  Likewise,
vulnerabilities in interrupt context will only have one chance, as will
any issue where failed exploitation prevents subsequent attempts, as is
frequently the case due to failures to clean up locking primitives on an
OOPS.

-Dan

> -Kees
> 
> -- 
> Kees Cook
> Ubuntu Security Team


