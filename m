Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1ABJLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:11:47 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257Ab1ABJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:11:43 -0500
Date: Sun, 2 Jan 2011 10:11:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch] x86: avoid unnecessary smp alternatives switch during
	suspend/resume
Message-ID: <20110102091142.GA32469@atrey.karlin.mff.cuni.cz>
References: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com> <4CE8E60D.9000303@nigelcunningham.com.au> <20101121100328.GA2939@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121100328.GA2939@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > We have a few others things that want to modify their behaviour
> > according to whether we're doing the atomic copy/restore. Perhaps it
> > would be an idea to just use a single flag, perhaps a value for
> > system_state?
> 
> I agree, it would be nicer if we don't introduce a special flag
> just for that. Other than that, I like all sane code that speeds up
> suspend/resume :). I've attached before/after dmesg excerpts on my
> system with the patch ontop of v2.6.37-rc2-181-gb86db47. We end up
> saving 11601 ??secs according to CONFIG_PRINTK_TIME but hey, the code is
> simple enough :).

11msec is not worth the uglyness of global variable like this. Should
we get a parameter, or something?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
