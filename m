Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0LTS6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:58:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57006 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab0LTS6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:58:19 -0500
Date: Mon, 20 Dec 2010 19:58:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Tony Luck <tony.luck@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
Message-ID: <20101220185812.GA11285@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tony Luck <tony.luck@intel.com>, Tony Luck <tony.luck@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jim Keniston <jkenisto@linux.vnet.ibm.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
 <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
 <4D0BEE1F.7020008@zytor.com>
 <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
 <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
 <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
 <20101219091752.GA16150@liondog.tnic>
 <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
 <20101220072632.GA28020@liondog.tnic>
 <AANLkTikhbxs-FU2qjpup17QDd67R78puMNvP4GNRwiKX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikhbxs-FU2qjpup17QDd67R78puMNvP4GNRwiKX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 09:18:25AM -0800, Linus Torvalds wrote:
> On Sun, Dec 19, 2010 at 11:26 PM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > IOW, the simple (maybe too simple) algo of the pstore could be something
> > like:
> 
> Simple?
> 
> > 1. Got a relevant message from kernel, log it.
> >
> > 2. Am I still alive?
> 
> Umm. The "am I still alive" question is traditionally called "the
> stopping problem", and is considered to be the traditional example of
> _least_ simple problem there is. As in "fundamentally unsolvable".

Yeah, I meant simple in the sense of only two steps required.

> Did we kill X? Did we happen to hold some critical lock when oopsing?
> Was it syslogd itself that died and caused nothing further to be
> saved, even if the machine otherwise seems to be fine? Or did the
> filesystem go into read-only mode due to the problem and the rest of
> the system is fine, but the disk is never going to see the messages?
> 
> In other words, the problem really is that "am I still alive" thing.
> That's a seriously impossible question to answer.

Maybe we should rephrase this as "am I still alive and well," for a
specific definition of well.

> What _can_ be answered is "did somebody write out the oops, then
> fsync, and then notify us about it?" But without explicit notification
> of "yeah, it really is saved off somewhere else", we really can't
> tell.

That could work, I should look deeper into that.

> We could do heuristics, of course, and they might even work in
> practice (like "flush after half an hour if there has been actual work
> done and the machine is clearly making progress").

Yes, this was exactly what I was trying to say! Do something in a
watchdog handler path that shows that we actually made progress. But
you're right, we'd still need the notification. My look at "did we make
a progress" was too simple and there _are_ nuances which need to be
accounted for.

Thanks.

-- 
Regards/Gruss,
    Boris.
