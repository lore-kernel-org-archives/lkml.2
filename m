Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab0LNX5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:57:37 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23369 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab0LNX5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:57:35 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
Date: Tue, 14 Dec 2010 16:57:27 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
References: <20101208213606.13026.47657.stgit@bob.kio> <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com> <AANLkTi=a4kOssPYfdYHW5yn9q03=2_6v4bZeCj4iGsUi@mail.gmail.com>
In-Reply-To: <AANLkTi=a4kOssPYfdYHW5yn9q03=2_6v4bZeCj4iGsUi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141657.28244.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 14, 2010 01:44:51 pm Linus Torvalds wrote:
> On Tue, Dec 14, 2010 at 12:34 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That's a maintainable approach. But it's maintainable ONLY if we then
> > don't do other random changes that invalidates all the years of
> > testing we've had.
> 
> Btw, looking at all the x86-specific commits that have gone in, I'm
> *extremely* unhappy that they apparently stopped honoring that
> "resource_alloc_from_bottom" flag that I explicitly asked for.

In 20-20 hindsight, I should have made that switch affect more things.
I tried to do what you asked; I obviously just didn't do enough, and
I am sorry.

> So it looks like it's not enough to just set that flag. We have to
> actually revert all the commits in this area as broken.
> 
> Which is sad, but since they clearly *are* broken and don't honor the
> flag that was there explicitly to avoid this problem and make it easy
> to test reverting it, I'm really pissed off. The WHOLE POINT of that
> flag was to give people an option to say "use the old resource
> allocation order because the new one doesn't work for me".
> 
> So at this point the only question is whether I should just revert the
> whole effing lot, or whether there are patches to fix the code to
> honor the "allocate from bottom" bit and then just set it by default
> again.
> 
> Bjorn? Preferences?

Let me identify the set of reversion candidates and the consequences,
and then we can figure out whether it's better to retreat or push
forward.

Bjorn
