Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0LQSTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:19:19 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43306 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883Ab0LQSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:19:18 -0500
Subject: Re: [concept & "good taste" review] persistent store
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	 <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	 <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	 <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 13:19:12 -0500
Message-ID: <1292609952.2820.43.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 10:09 -0800, Tony Luck wrote:
> On Thu, Dec 16, 2010 at 10:28 PM, Tony Luck <tony.luck@gmail.com> wrote:
> >> The _only_ valid reason for persistent storage is for things like
> >> oopses that kill the machine.
> >
> > Maybe I misunderstood what "KMSG_DUMP_OOPS" meant ... it
> > looked to me like this code is used for non-fatal OOPsen - ones
> > that will be logged to /var/log/messages.
> 
> Thinking about this a bit more I see my experiments with
> this were hopelessly naive. There is no way to know at
> "oops" time whether the problem is going to turn out to
> be minor or fatal.  So the right thing to do here is assume
> the worst and squirrel the data away safely just in case
> death is imminent.

To be honest, this is what I'd recommend even if you could tell the
difference.  A lot of the oopses I see were triggered by something
non-fatal (usually a WARN_ON()) earlier in the sequence.  Without seeing
the preceding WARN_ON() data, the oops is usually terrifically hard to
diagnose (often just a NULL or junk pointer deref).

James


