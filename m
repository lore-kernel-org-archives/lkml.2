Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0LSRBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 12:01:22 -0500
Received: from ist.d-labs.de ([213.239.218.44]:39408 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0LSRBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 12:01:20 -0500
Date: Sun, 19 Dec 2010 18:01:09 +0100
From: Florian Mickler <florian@mickler.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
Message-ID: <20101219180109.3c042e43@schatten.dmk.lab>
In-Reply-To: <20101219091752.GA16150@liondog.tnic>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	<AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
	<AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
	<AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
	<4D0BEE1F.7020008@zytor.com>
	<AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
	<AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
	<AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
	<20101219091752.GA16150@liondog.tnic>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Dec 2010 10:17:52 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Dec 18, 2010 at 03:06:57PM -0800, Tony Luck wrote:
> > > Doesn't that sound like the best of both worlds?
> > 
> > It sounds like an excellent heuristic for how the platform layer
> > should manage the persistent store when space is tight. But
> > I think that I can still keep my /dev/pstore filesystem as a
> > presentation layer to make the bits available to the user in
> > a device independent way.
I agree. As far as I understand, Linus concept could map nicely onto an
fs:

1. marking things read:
	Clients can delete files as soon as they have savely scribled
	them down somewhere. 

2. on boot the persistent storage layer init's any files in an
'archive' directory. 

3. if an oops happens, the persistent storage layer shows them in the
pstore-root directory. If no space is left, the
persistent storage layer evicts as much oldest entries from the
'archive' as necessary. as soon as archive is empty but the pstore is
full, pstore stops storing new oopses.

Or not? That way, there would be some sort of journal behaviour, but
also new oopses will evict old(pre-boot) oopses if necessary. 
maybe a kernel boot-parameter to disable deleting old oopses could be
necessary in some cases. But I doubt it.

Regards, 
Flo

