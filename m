Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0FIJNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:13:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41369 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab0FIJNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:13:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Regression: BUG when battery is removed before resuming from hibernation
Date: Wed, 9 Jun 2010 11:14:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4C0E40E1.2080108@tuffmail.co.uk> <201006082252.49452.rjw@sisk.pl> <4C0F59C8.8020704@tuffmail.co.uk>
In-Reply-To: <4C0F59C8.8020704@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006091114.43373.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 June 2010, Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday 08 June 2010, Alan Jenkins wrote:
> >   
> >> I found this bug 2.6.34 on my Asus EeePC 701 (x86_32 arch).  It didn't 
> >> happen to me before, when I was running nearly-2.6.33 or 2.6.32-release.
> >>
> >> I used git-bisect, but unfortunately the result isn't very helpful.  My 
> >> next step will be to try to narrowing down the culprits by disabling 
> >> individual CONFIG options.  Here are my results so far, in case anyone 
> >> is interested.
> >>
> >>
> >> == Steps to reproduce ==
> >>
> >> I) Boot off mains power, with battery removed.  Login to KDE4 session, 
> >> with Konsole as the only running application.
> >> II) Run "sudo pm-hibernate"
> >>
> >> 1. When the system switches to text mode (a.k.a the console), 
> >> immediately insert the battery.
> >> 2. Once the system has fully hibernated, remove the battery.
> >> 3. Press the power button to resume.  The backtrace below is generated 
> >> during resume.
> >>     
> >
> > You're not supposed to be doing that.
> >
> > Rafael
> >   
> 
> I take it you mean "don't plug devices in during hibernation; you'll run 
> out of memory, Bad Things will happen, and you can expect resume to 
> fail".  Pity.  It wasn't an artificial test case, just an unusual usage 
> pattern of mine[1].
> 
> I guess it wouldn't be guaranteed safe even if I was plugging the device 
> in first.  The battery connection could take a few seconds to stabilize, 
> and there's software equivalents in things like the usb-storage delay.
> 
> I can't complain about safety margins; other people might want to do 
> similar things with an entire docking station...
> 
> Any chance of a big screaming warning?

It is possible, but certainly not a priority.  

> IIRC there's one global flag to 
> fail userspace call-outs while userspace is frozen.  Would it be 
> acceptable to document this in code & behaviour by aborting the 
> hibernation on hot-plug?  (hot-*un*plug would presumably be allowed).

Ditto.

Rafael
