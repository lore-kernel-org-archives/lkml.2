Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1A2VQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 16:16:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49425 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1A2VQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 16:16:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [RFC] merge 32/64 bits realmode wakeup code
Date: Sat, 29 Jan 2011 22:15:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
References: <4D41EA12.1030402@free.fr> <201101272354.00042.rjw@sisk.pl> <4D447C00.70709@free.fr>
In-Reply-To: <4D447C00.70709@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101292215.57292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 29, 2011, matthieu castet wrote:
> Rafael J. Wysocki a écrit :
> > On Thursday, January 27, 2011, matthieu castet wrote:
> >> Hi,
> >>
> >> this patch merge 32 and 64 realmode wakeup code :
> >> - this mean less ifdef in code
> >> - we could remove now unused field in wakeup_header (pmode_*)
> >> - this allow to set the first 1 MB NX.
> >>
> >> Do you think it is safe on all X86 32 bit machine ?
> >>
> >> Matthieu
> >>
> >>
> >> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > 
> > It _looks_ sane, but it will require some serious testing.  I'm not sure,
> > though, if we can get enough testing coverage without actually committing
> > that change.
> > 
> > How much testing has it received so far?
> > 
> Not too much only qemu with 1 and 2 core and a laptop with 1 cpu.
> 
> Please note that with this patch we can also remove the gdt, idt, ldt stuff from 
> arch/x86/kernel/acpi/wakeup_32.S

That's correct, but those changes can wait.  The most urgent thing is to fix
the resume regression at hand.  I guess we should ask the reporter's in
https://bugzilla.kernel.org/show_bug.cgi?id=27472 to test that patch, right?

Rafael
