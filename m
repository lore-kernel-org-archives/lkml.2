Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1HRSjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:39:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1HRSju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:39:50 -0400
Date: Thu, 18 Aug 2011 20:36:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/41] signal: Use set_current_blocked()
Message-ID: <20110818183659.GA10353@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <20110811160358.GA7989@redhat.com> <1313523659.3436.184.camel@mfleming-mobl1.ger.corp.intel.com> <20110817170152.GA22499@redhat.com> <1313619446.2311.52.camel@mfleming-mobl1.ger.corp.intel.com> <1313665755.2311.57.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313665755.2311.57.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, Matt Fleming wrote:
>
> On Wed, 2011-08-17 at 23:17 +0100, Matt Fleming wrote:
> >
> > This does look like a decent clean up, especially because so many
> > architectures got this sequence wrong in the past. But yeah, it will
> > require me to rewrite half my series ;-)
> >
> > Is it worth rewriting the series? Dunno. I'm not convinced that the
> > wrapper buys us enough for that,

Oh, I am not sure too. I almost regret I mentioned this cleanup. Just
I was a bit suprised by how many arches do this wrong. See also below.

> plus it'd increase the number of
> patches.

By 1. A single patch can convert the code to use set_current_blocked()
and block_sigmask().

And probably the patch which adds block_sigmask() should change arch/x86
as well, this makes its purpose immediately clear. IOW, I'd prefer the
patch I sent (with rename). But once again, I won't persist.

> > Maybe it'd be better to do it as a separate set of patches?

I don't think so... this means another series touching arch/* to
make the very minor cleanup.

> OK so, I went ahead and rewrote the series using your clean up. It's in
> the 'oleg/set-current-blocked-v2' branch at,
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux-2.6.git
>
> Would you mind taking a quick look and see which series you prefer?

No, no, no. Matt, please choose the series which _you_ prefer. You
are the author. I am fine either way.

> I resend any patches.

Yes. I think you should resend the whole series in any case. Because
I think our discussion could confuse the maintainers.


Can I ask you to CC them all in 00/XX ? In this case I can reply
to 00 saying that I am going to take the whole series, unless the
maintainer want to do this. Otherwise I should reply per-arch, this
will certainly cause the confusion.

And, Matt, if I take the patch and then we have any sort of conflict,
you will have to help me with the git problems ;) My understanding
of git magic is quite limited.

Oleg.

