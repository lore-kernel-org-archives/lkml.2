Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1GDM5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 08:57:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54631 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1GDM5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 08:57:50 -0400
Date: Mon, 4 Jul 2011 14:57:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/6] x86,64: Simplify save_regs()
Message-ID: <20110704125742.GB1915@somewhere.redhat.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-4-git-send-email-fweisbec@gmail.com>
 <4E1185F3020000780004BF21@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1185F3020000780004BF21@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 08:20:51AM +0100, Jan Beulich wrote:
> >>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > The save_regs function that saves the regs on low level
> > irq entry is complicated because of the fact it changes
> > its stack in the middle and also because it manipulates
> > data allocated in the caller frame and accesses there
> > are directly calculated from callee rsp value with the
> > return address in the middle of the way.
> > 
> > This complicates the static stack offsets calculation and
> > require more dynamic ones. It also needs a save/restore
> > of the function's return address.
> > 
> > To simplify and optimize this, turn save_regs() into a
> > macro.
> 
> So this got pulled out into a function a couple of releases ago,
> and now it's being converted back? Wasn't the original patch's
> intention to reduce the amount of duplication of generated
> code?

Right. I didn't know there was a conversion a while ago for
this save_regs() from a macro to a func in order to remove
code duplication.

I really did not think about code duplication, considering
it's better to optimize the irq entry path.

What do you guys think? We can still revert the whole patchset.
