Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1BNTCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:02:32 -0500
Received: from www.tglx.de ([62.245.132.106]:54545 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1BNTC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:02:29 -0500
Date: Mon, 14 Feb 2011 20:01:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
In-Reply-To: <20110213125053.GA28968@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.00.1102141958020.26192@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com> <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6> <AANLkTin3o9eFjpe6TMmKb5LSRUT+0Y2EpD4OU4LzN8Kd@mail.gmail.com>
 <alpine.LFD.2.00.1102110135320.31804@localhost6.localdomain6> <alpine.LFD.2.00.1102111359580.31804@localhost6.localdomain6> <20110211135906.GA16358@elte.hu> <alpine.LFD.2.00.1102111516020.31804@localhost6.localdomain6>
 <20110213125053.GA28968@merkur.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-2023052230-1297710104=:26192"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-2023052230-1297710104=:26192
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 13 Feb 2011, Sam Ravnborg wrote:

> On Fri, Feb 11, 2011 at 03:26:11PM +0100, Thomas Gleixner wrote:
> > On Fri, 11 Feb 2011, Ingo Molnar wrote:
> > > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > > >  129 files changed, 4353 insertions(+), 5400 deletions(-)
> > > 
> > > Did I get the file count right - roughtly how many files are affected throughout all 
> > > architectures? The changes are massively intrusive and widely spread out so we 
> > > cannot do them in one go, right?
> > 
> > Alone the stuff which fiddles in irq_desc->status for whatever reasons
> > is >100 files in arch/. And that has do be done manually case by case.
> 
> Some kind of arch TODO list wold be nice. Just to let the arch maintainers
> know what you expect from them (on top of the deprecated warnings).

One thing which can be done right now is to use the proper existing
accessors irq_to_desc(), irq_set/clear_status_flags().

The remaining fixes depend on the yet to be merged queue. I will do
the namespace cleanup with cocinelle after rc1 as this is purely
mechanical. The other few things which will be left need manual
attendance, I will post either patches or a TODO list.

Thanks,

	tglx
---1463795968-2023052230-1297710104=:26192--
