Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1EGNQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 09:16:45 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:10928 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1EGNQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 09:16:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19909.17976.119505.890308@pilspetsen.it.uu.se>
Date: Sat, 7 May 2011 15:16:40 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Arnd Bergmann <arnd@arndb.de>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
In-Reply-To: <BANLkTinssNTc_+=F4CA1Znb3bdv=c30OPw@mail.gmail.com>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
	<19907.2804.330120.193924@pilspetsen.it.uu.se>
	<BANLkTinssNTc_+=F4CA1Znb3bdv=c30OPw@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 May 2011 10:34:25 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, May 5, 2011 at 22:39, Mikael Pettersson <mikpe@it.uu.se> wrote:
> > Geert Uytterhoeven writes:
> > =C2=A0> On Thu, 5 May 2011, Arnd Bergmann wrote:
> > =C2=A0> > Did you check the macros in unistd to see if they match the
> > =C2=A0> > actual table? I guess it would be a good time to comment out
> > =C2=A0> > the ones that are not implemented in either of the two ABIs.
> > =C2=A0>
> > =C2=A0> Like this?
> > =C2=A0>
> > =C2=A0> warning: #warning syscall pselect6 not implemented
> > =C2=A0> warning: #warning syscall ppoll not implemented
> > =C2=A0> warning: #warning syscall recvmmsg not implemented
> > =C2=A0>
> > =C2=A0> Do we need pselect6 and ppoll? I have vague memories not requirin=
> g it.
> >
> > They close user-space race conditions, so you want them.
> 
> So do you recommend to backport the wiring up of pselect6/ppoll to -stable?
> We always had their _NR_* defines, so I guess glibc was always compiled
> with pselect6/ppoll support, and will use it if it's present.

Any kernel with working TIF_RESTORE_SIGMASK should ideally also
wire up pselect6/ppoll.  But their omission is not a regression
so backporting to 2.6.38 is probably sufficient.

/Mikael
