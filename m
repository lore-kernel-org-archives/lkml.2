Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0G2PNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:13:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab0G2PNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:13:30 -0400
Date: Thu, 29 Jul 2010 11:16:51 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100729151650.GA20261@redhat.com>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org> <4C5148A5.10809@suse.cz> <20100729144748.GI6249@redhat.com> <4C519899.9020206@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C519899.9020206@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 05:04:57PM +0200, Michal Marek wrote:
> On 29.7.2010 16:47, Aristeu Rozanski wrote:
> > On Thu, Jul 29, 2010 at 11:23:49AM +0200, Michal Marek wrote:
> >> On 29.7.2010 10:13, Sam Ravnborg wrote:
> >>> On Wed, Jul 28, 2010 at 10:36:22PM +0200, Sam Ravnborg wrote:
> >>>> Hi Michal.
> >>>>
> >>>> I cooked up the following to introduce long options in conf.
> >>>> But in the process I dropped the short options. Is this OK?
> >>>
> >>> On top of this patch I did another two.
> >>> They fixup the *nonint_oldconfig targets:
> >>>
> >>> nonint_oldconfig:
> >>> - renamed to listnewconfig
> >>> - print new options to stdout (to better support redirect)
> >>> - no longer saves a new configuration
> >>> - does ot exist with a failure code if there is new options
> > but this kills its usefulness. nonint_oldconfig is used so you can script
> > the use of a generated configuration (think distro kernel RPMs). if something
> > is not set, it fails listing what's not set. otherwise it'll save the
> > configuration and whatever script is using it can proceed.
> > "listnewconfig" is a new, different target to me.
> 
> How about
> new=$(make listnewconfig)
> if test -n "$new"; then
>     echo "Please set the following options:" >&2
>     echo "$new" >&2
>     exit 1
> fi
> ? Wouldn't that be the same as nonint_oldconfig before?
what's the other use cases for listnewconfig (other than a incomplete
nonint_oldconfig)?

-- 
Aristeu

