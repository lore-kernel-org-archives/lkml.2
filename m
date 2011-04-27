Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1D0Om2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:42:28 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:40496 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751074Ab1D0Om0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:42:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=diYaDqU7NNv/Gp8v32UjqqZetMsC9TQk9N3URuHSkD5WkSMsbp4ClkK1tuvV2jTD63e1UVZvmSL7AMXCAg3nVdvWjKfFsu80ARhGGOT4nxTx+f9tJPU73Cfrfbf2wAjg;
Date: Wed, 27 Apr 2011 07:42:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Foley <pefoley2@verizon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT
 menu kconfig symbols
Message-Id: <20110427074223.9309ac0b.rdunlap@xenotime.net>
In-Reply-To: <BANLkTimsFd-LfT6wF-iYPY7TNqR0q388XA@mail.gmail.com>
References: <20110426130036.997a05fc.rdunlap@xenotime.net>
	<alpine.DEB.2.00.1104261608210.7639@chino.kir.corp.google.com>
	<BANLkTimsFd-LfT6wF-iYPY7TNqR0q388XA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 09:56:06 +0200 Geert Uytterhoeven wrote:

> On Wed, Apr 27, 2011 at 01:09, David Rientjes <rientjes@google.com> wrote:
> > On Tue, 26 Apr 2011, Randy Dunlap wrote:
> >
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Surround the EXPERT menu with "if EXPERT" and "endif" so that it
> >> is forced to stay as one unit.  Hopefully this will help to prevent
> >> it being broken in the future.
> >>
> >> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >> Cc: David Rientjes <rientjes@google.com>
> >> Cc: Peter Foley <pefoley2@verizon.net>
> >> ---
> >>  init/Kconfig |   36 ++++++++++++++++++++----------------
> >>  1 file changed, 20 insertions(+), 16 deletions(-)
> >>
> >> --- lnx-2639-rc4.orig/init/Kconfig
> >> +++ lnx-2639-rc4/init/Kconfig
> >> @@ -924,15 +924,17 @@ menuconfig EXPERT
> >>            environments which can tolerate a "non-standard" kernel.
> >>            Only use this if you really know what you are doing.
> >>
> >> +if EXPERT
> >> +
> >>  config UID16
> >> -     bool "Enable 16-bit UID system calls" if EXPERT
> >> +     bool "Enable 16-bit UID system calls"
> >>       depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
> >>       default y
> >>       help
> >>         This enables the legacy 16-bit UID syscall wrappers.
> >>
> >
> > I don't like this, people who look up a Kconfig option typically only
> > look at the single entry and look for dependencies within it, not the
> > context in which it is declared in the Kconfig file.
> 
> What about extracting the part that depends on EXPERT into its own file
> init/Kconfig.expert?
> 
> Using separate Kconfig.xxx files could become a Kconfig pattern...

Yes, I thought of that last night also.  Yes, it could help.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
