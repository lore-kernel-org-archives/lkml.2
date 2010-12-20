Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0LTH0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 02:26:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37213 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab0LTH0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 02:26:39 -0500
Date: Mon, 20 Dec 2010 08:26:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
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
Message-ID: <20101220072632.GA28020@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>, Tony Luck <tony.luck@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jim Keniston <jkenisto@linux.vnet.ibm.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
 <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
 <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
 <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
 <4D0BEE1F.7020008@zytor.com>
 <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
 <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
 <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
 <20101219091752.GA16150@liondog.tnic>
 <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 12:17:53PM -0800, Tony Luck wrote:
> > So, I think what we could do is keep our big enough pstore with enough
> > free space for a bunch of oopses in case we panic. In the remaining
> > cases, we write them out thus freeing some more space.
> 
> Some feedback from syslogd (or whatever it is that gets things from
> dmesg into /var/log/messages) would help here ... though to be really
> useful it might need "fsync" to /var/log/messages, which might not
> be a welcome addition.

Right.

However, AFAICT, all warnings/oopses go to dmesg anyway and from there
to syslog so actually there should be no need to save them in pstore
too, methinks.

IOW, the simple (maybe too simple) algo of the pstore could be something
like:

1. Got a relevant message from kernel, log it.

2. Am I still alive?
|-> yes => Ah ok, non-critical, it should be in the logs anyway, drop last message set from pstore.
|-> no  => Well I can't do here anything anyway, I'm dead... note-to-self: Show last messages set to user upon next boot.

So, the pstore should actually be constantly almost empty rather than
almost full. And it definitely is going to contain the last critical
oops which may or may not be in the syslog.

Or am I missing something?

Thanks.

-- 
Regards/Gruss,
    Boris.
