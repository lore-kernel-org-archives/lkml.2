Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0LVAdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:33:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0LVAdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:33:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1292977616.8743.87.camel@yhuang-dev>
References: <1292977616.8743.87.camel@yhuang-dev> <1292892072.8743.70.camel@yhuang-dev> <1292813234.8743.66.camel@yhuang-dev> <4d0662e511688484b3@agluck-desktop.sc.intel.com> <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com> <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com> <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com> <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com> <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com> <4D0BEE1F.7020008@zytor.com> <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com> <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com> <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com> <20101219091752.GA16150@liondog.tnic> <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com> <17027.1292841992@redhat.com> <32058.1292926258@redhat.com> 
To: Huang Ying <ying.huang@intel.com>
Cc: dhowells@redhat.com, "Luck, Tony" <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
Date: Wed, 22 Dec 2010 00:32:24 +0000
Message-ID: <8362.1292977944@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> wrote:

> The user space program (syslogd) is in my big picture, it will guarantee
> an oops meesage actually go to disk via something like fsync.  After
> doing that, the user space program can erase the corresponding record in
> persistent storage to free the space.  So all in all, oops messages not
> causing system panic or disk error will go to disk eventually and being
> freed and will not use up the persistent storage.

I see.  So you rely on fsync() to hang forever if the message can't be written
to disk because an oops killed the write path?

David
