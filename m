Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059Ab2KARuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 13:50:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61994 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2KARuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 13:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<2548314.3caaFsMVg6@linux-lqwf.site>
	<50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
	<1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
Date: Thu, 1 Nov 2012 13:50:08 -0400
Message-ID: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Eric Paris <eparis@parisplace.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 11:18 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> You're completely confusing two separate goals:
>
>      1. Is it possible to use secure boot to implement a security policy
>         on Linux
>      2. What do we have to do anything to prevent Linux being used to
>         attack windows which may lead to a revocation of the distro
>         signing key.
>
> "untrusted root" is a silly answer to 1 because it's incredibly
> difficult to remove sufficient trust from root and still have it be
> trusted enough to be effective as root.  The trust bound up in root is
> incredibly intertwined.  It would be far better to start by eliminating
> the root user altogether and building up on the capabilities in a
> granular fashion for this type of lockdown.

granular lockdown!?  sounds like SELinux.  But that certainly can't
solve the problems here...

I think your premise has a couple of problems.  First is how you chose
to word #2.  Lets reword it as:

What do we have to do to prevent Linux being used to attack Linux
which may lead to secure boot being useless.

If we accept that as #2, then we think, "What makes secure boot
useless"  or "What is the security goal as envisioned by secure boot."
 The goal of secure boot is to implement an operating system which
prevents uid==0 to ring 0 escalation.  That is the security policy
secure boot needs to not be completely useless.  And as it turns out,
that security policy is useful in other situations.

> "untrusted root", if it can even be achieved, might be a sufficient
> condition for 2 but it's way overkill for a necessary one.

But it is a condition, as specifically stated, that others have wanted
long before secure boot even came to rise.  I've talked with and
worked with a public cloud operator who wants to prevent even a
malicious root user from being able to run code in ring 0 inside their
VM.  The hope in that case was that in doing so they can indirectly
shrink the attack surface between virtual machine and hypervisor.
They hoped to limit the ways the guest could interact to only those
methods the linux kernel implemented.

They want to launch a vm running a kernel they chose and make sure
root inside the vm could not run some other kernel or run arbitrary
code in kernel space.  It's wasn't something they solved completely.
If it was, all of this secure boot work would be finished.  Which is
why we are having these discussions to understand all of the way that
you an Alan seem to have to get around the secure boot restrictions.
And look for solutions to retain functionality which meeting the
security goal of 'prevent uid=0 to ring 0 privilege escalation.

-Eric
