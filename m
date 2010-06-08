Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0FHBNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 21:13:41 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42388 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752051Ab0FHBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 21:13:40 -0400
Date: Mon, 7 Jun 2010 21:13:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Vitaly Wool <vitalywool@gmail.com>,
       Neil Brown <neilb@suse.de>, <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTimf_nVcOZGi0x6nDtaO-FMVSLPrxDtOzQwKTB5P@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1006072110550.26784-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Arve Hjønnevåg wrote:

> > Remember that suspend takes place in several phases, the first of which
> > is to freeze tasks.  The phases can be controlled individually by the
> > process carrying out a suspend, and there's nothing to prevent you from
> > stopping after the freezer phase.  Devices won't get powered down, but
> > Android uses aggressive runtime power management for its devices
> > anyway.
> >
> > If you do this then the synchronization can be carried out entirely
> > from userspace, with no need for kernel modifications such as suspend
> > blockers. And since Android can reach essentially the same low-power
> > state from idle as from suspend, it appears that they really don't need
> > any kernel changes at all.
> >
> 
> I don't think this is true. If you stop after the freezer phase you
> still need all the suspend blockers that are held until user-space
> consumes an event, otherwise it never gets consumed since user-space
> is frozen.

No.  You don't need to hold any suspend blockers; you merely need to 
unfreeze userspace.  Once it is unfrozen, it will eventually consume 
the wakeup event.

What you _do_ need to do is to prevent userspace from getting frozen 
again too soon.  That's the purpose of the list of "active" wakeup 
sources.  So long as the power manager believes a source is still 
active, it won't freeze anything.

Alan Stern

