Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2HNBSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:18:35 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40521 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2HNBSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:18:33 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.46.74
Date: Mon, 13 Aug 2012 18:18:26 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Thai Bui <blquythai@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
Message-ID: <20120814011826.GA2255@leaf>
References: <1344891431-30869-1-git-send-email-blquythai@gmail.com>
 <20120813212151.GA15429@phenom.dumpdata.com>
 <CAKkTMC5SP6LgWbhtkU_HCBUAfArGuHXtp4mcwi2tFTjZOwVQbA@mail.gmail.com>
 <5029823A.9020207@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029823A.9020207@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:39:54PM -0700, Randy Dunlap wrote:
> On 08/13/2012 03:08 PM, Thai Bui wrote:
> >Hi all,
> >
> >I am as part of a capstone group at Portland State University is working
> >to tinify the kernel as small as possible. The ultimate goal is to make
> >the kernel small enough to use on micro-controller (or under < 200k).
> >This patch is one of them, it saves 176 bytes on a minimal configuration
> >of the kernel (the bzImage file was reduced from 363264 bytes to 363264
> >bytes applying this patch).
> >
> >Aside from the purpose of reducing the size of the kernel. We are also
> >trying to clean up the kernel by making Kconfig options to compile out
> >the stuffs that aren't used often.
> 
> IMO the kernel already has too many kconfig options.
> 
> Also, personally I would not merge a patch that saves so little memory,
> especially on what I consider a very useful option.

I think Thai undersold his patch significantly; the *compressed* size
went down by 176 bytes, and the uncompressed size went down more than
that.  And that's the savings starting from a very minimal kernel, not
starting from a defconfig kernel.

In any case, do you object to the introduction of a Kconfig option at
all, or to that option defaulting to off?  In particular, would you
object if the option only showed up if EMBEDDED, and defaulted to y?  At
that point, you could reasonably expect that most users and distros will
have it enabled, so you'll be able to count on asking people to enable
it and send you the output.  Would that suffice?

The patch itself seems incredibly straightforward and non-invasive to
me; it just stubs out the global variable and lets GCC fold away all the
code.

At this point, the kernel is running out of major things to cut out to
save space; getting from ~200k (the current smallest kernel possible) to
much less than that will require a pile of patches that save anywhere
from a few hundred bytes to a few kilobytes.  I certainly agree that
those patches need to avoid introducing too much complexity.  However, I
don't think it makes sense to object to a patch that saves space solely
on the grounds that it doesn't save *more* space.  That would make it
impossible to cut out small things, and small things add up.

- Josh Triplett
