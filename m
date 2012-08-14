Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2HNMuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:50:12 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43529 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab2HNMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:50:10 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.46.74
Date: Tue, 14 Aug 2012 05:50:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Thai Bui <blquythai@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
Message-ID: <20120814125002.GA8125@leaf>
References: <1344891431-30869-1-git-send-email-blquythai@gmail.com>
 <20120813212151.GA15429@phenom.dumpdata.com>
 <CAKkTMC5SP6LgWbhtkU_HCBUAfArGuHXtp4mcwi2tFTjZOwVQbA@mail.gmail.com>
 <5029823A.9020207@xenotime.net>
 <20120814011826.GA2255@leaf>
 <CA+5PVA6dzzP=go8M=gDRN79DovC6QiuA3sy=2bdgmn3vdZp_zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6dzzP=go8M=gDRN79DovC6QiuA3sy=2bdgmn3vdZp_zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 08:03:41AM -0400, Josh Boyer wrote:
> On Mon, Aug 13, 2012 at 9:18 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Mon, Aug 13, 2012 at 03:39:54PM -0700, Randy Dunlap wrote:
> >> On 08/13/2012 03:08 PM, Thai Bui wrote:
> >> >Hi all,
> >> >
> >> >I am as part of a capstone group at Portland State University is working
> >> >to tinify the kernel as small as possible. The ultimate goal is to make
> >> >the kernel small enough to use on micro-controller (or under < 200k).
> >> >This patch is one of them, it saves 176 bytes on a minimal configuration
> >> >of the kernel (the bzImage file was reduced from 363264 bytes to 363264
> >> >bytes applying this patch).
> >> >
> >> >Aside from the purpose of reducing the size of the kernel. We are also
> >> >trying to clean up the kernel by making Kconfig options to compile out
> >> >the stuffs that aren't used often.
> >>
> >> IMO the kernel already has too many kconfig options.
> >>
> >> Also, personally I would not merge a patch that saves so little memory,
> >> especially on what I consider a very useful option.
> >
> > I think Thai undersold his patch significantly; the *compressed* size
> > went down by 176 bytes, and the uncompressed size went down more than
> > that.  And that's the savings starting from a very minimal kernel, not
> > starting from a defconfig kernel.
> >
> > In any case, do you object to the introduction of a Kconfig option at
> > all, or to that option defaulting to off?  In particular, would you
> > object if the option only showed up if EMBEDDED, and defaulted to y?  At
> > that point, you could reasonably expect that most users and distros will
> > have it enabled, so you'll be able to count on asking people to enable
> > it and send you the output.  Would that suffice?
> 
> Hiding it behind EMBEDDED might be a start.  From a distro perspective,
> we actually use this particular option quite often so keeping the
> ability to use it as you describe is important.

Fair enough.

> > The patch itself seems incredibly straightforward and non-invasive to
> > me; it just stubs out the global variable and lets GCC fold away all the
> > code.
> >
> > At this point, the kernel is running out of major things to cut out to
> > save space; getting from ~200k (the current smallest kernel possible) to
> > much less than that will require a pile of patches that save anywhere
> > from a few hundred bytes to a few kilobytes.  I certainly agree that
> > those patches need to avoid introducing too much complexity.  However, I
> > don't think it makes sense to object to a patch that saves space solely
> > on the grounds that it doesn't save *more* space.  That would make it
> > impossible to cut out small things, and small things add up.
> 
> If you're really going to pursue that, I'd suggest hiding the removals
> behind a new option that most people won't set.

Most of the other options added via this project have used EXPERT or
EMBEDDED.  This one originally seemed enough like a debugging option to
warrant just using DEBUG_KERNEL and let it default to N, but it sounds
like this one needs to use EMBEDDED as well.

- Josh Triplett
