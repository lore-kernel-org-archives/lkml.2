Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab1KBQfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:35:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10794 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933462Ab1KBQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:35:00 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183qc17a8uMQ5FQDZK7JfDi
Date: Wed, 2 Nov 2011 09:34:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 0/13 (12)] arm-soc updates
Message-ID: <20111102163454.GH31337@atomide.com>
References: <201111020322.46469.arnd@arndb.de>
 <CA+55aFzCyQ1fyTs5ZbcGD_gCVX0oA99NiLEsxMtJ1h9xf_-v9A@mail.gmail.com>
 <201111021518.05477.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111021518.05477.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [111102 06:43]:
> On Wednesday 02 November 2011, Linus Torvalds wrote:
> > On Tue, Nov 1, 2011 at 7:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > I have a series of 12 pull requests for the arm-soc tree, a total of 409
> > > non-merge commits. Feel free to pull either the for-linus branch that contains
> > > the lot with all conflicts resolved or the individual pull requests.
> > 
> > Ok, I did the individual merges, because I really want to know what
> > horrible things go on there. Ugh.
> >
> > But I did compare it against your pre-merged thing, and there are some
> > differences. I think my version of the arch/arm/mach-omap2/Makefile
> > thing is better, for example (you seem to have the OMAP4_PANDA and
> > OMAP3517EVM boards duplicated). And the arch/arm/plat-omap/devices.c
> > difference is just a matter of taste.
> 
> Right, your version looks better in both cases.

Yes thanks Arnd & Linus, what got merged is correct.
 
> > But the arch/arm/mach-omap2/board-generic.c difference is real. You
> > left a lot more header file includes in place, while my merge looked
> > at the previous commits and merges that removed a lot of them - and
> > followed suit. Maybe there was some reason you didn't?
> 
> I've done this merge a few times. I think at one point I got it right,
> but the version I had in my combined branch used an earlier merge
> that got back through rerere. I'll try to watch out for these in the
> future.
> 
> > Also, your tree removed the atag_offset lines that weren't even content
> > conflicts, and again, there may have been some reason for that?
> 
> This one was intentional, but it's not very important either. The
> conflict was between 5e52b435b "ARM: mach-omap2: convert boot_params
> to atag_offset" and 8d61649 "ARM: OMAP2+: board-generic: Add DT support
> to generic board" and . The first one changed the method how to
> find the traditional "atag" data structure, the second patch moved
> the file over from having one atag (and board number) based entry
> to having three distinct device tree based machine descriptions, which
> obsoletes the atag_offset/boot_params.
> 
> I had originally merged them incorrectly and it seems that this mismerge
> ended up in your tree now. It's harmless because the atag_offset is
> ignored here, but I'll send a cleanup after checking all other files
> that may have the same problem.

This merge too is correct. Looks like there are some driver related
build errors from other pull requests, will post patches for those.

Regards,

Tony
