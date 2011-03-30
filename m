Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab1C3RHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:07:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab1C3RG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:06:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Wed, 30 Mar 2011 19:06:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk>
In-Reply-To: <20110318101512.GA15375@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301906.42429.arnd@arndb.de>
X-Provags-ID: V02:K0:zV9UnNmCaDRgXuQrkEJE4xNMpXte5Tcma91AjxjqyiW
 +jqi2v2KNGoM74eupP88DNm7iUm8fL1MsfhfYYyKBNPz9gr5x9
 Afw5+fkk5cylhLholOj5q95Uw/+w5W8xZ1jUHYRCATfmrKN/7a
 Suy9wGNkR6V7Q1Q24HVmVwPK9uUlik+R0w79ogcS0hslRhO3ZZ
 nodQKshiV0FwtVhVW2wNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Russell King - ARM Linux wrote:
> I do get the impression that you're extremely unhappy with the way ARM
> stuff works, and I've no real idea how to solve that.  I think much of
> it is down to perception rather than anything tangible.
> 
> Maybe the only solution is for ARM to fork the kernel, which is something
> I really don't want to do - but from what I'm seeing its the only solution
> which could come close to making you happy.

I'm still new to the ARM world, but I think one real problem is the way
that all platforms have their own trees with a very flat hierarchy --
a lot of people directly ask Linus to pull their trees, and the main
way to sort out conflicts is linux-next. The number of platforms in the
ARM arch is still increasing, so I assume that this only gets worse.

This would be no easier if everyone was asking you to pull their trees,
as I believe was the case before that. The amount of code getting changed
there is too large to get reviewed by a single person, and I believe
neither of you really wants the burden to judge if all of the branches
are ok (and complain to the authors when they are not).

Russell, do you think it would help to have an additional ARM platform
tree that collects all the changes that impact only the platform code but
not the core architecture? I believe that would be a way out, but requires
a careful selection of people responsible for it. In particular, I don't
think a single person can handle it without good sub-maintainers.

The way that x86 is maintained is to have a small group of people that
all have write access to one tree, so patches and branches from downstream
maintainers can get pulled by a number of people, when at least one of
them in totally comfortable with the contents and nobody else objects.
In case one of them is unhappy about something that went in, it can always
get reverted and will not be applied again until everybody is happy with it.

I think a similar setup would be possible for ARM, but only if you are
in the team, plus one person from at least ARM Ltd (Catalin?),
Linaro (Nicolas?) and maybe one or two more, but none of the actual
SoC vendors that produce the bulk of the code that would go in there.

It would also require buy-in from Linus eventually, to make it clear that
he would pull from that tree directly and no longer from other 
subarchitecture trees, once the process has been proven to work
for everyone.

I don't think I would want to be on the committers team myself, to make
it not too Linaro-heavy, but I can definitely offer a significant amount
of time for reviewing patches to be committed by someone else.

Also, I would assume that your own time would keep focused on the core
ARM tree that already keeps you busy enough.

	Arnd
