Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1BCOg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:36:59 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50630 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750920Ab1BCOg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:36:57 -0500
Date: Thu, 3 Feb 2011 15:36:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
 upon panic
Message-ID: <20110203143644.GA4085@ucw.cz>
References: <20110125134748.GA10051@laptop>
 <20110125140948.GA26762@elte.hu>
 <20110125150834.GD27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125150834.GD27510@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I think the biggest areas of practical concern would be:
> > 
> >  - Can this mechanism ever, under any circumstance corrupt any real
> >    data, destroy the MBR or do other nasties. Can you think of any
> >    additional fail-safe measures where you could _further robustify
> >    the BIOS calls_ to make sure it can never go to the wrong
> >    sector(s)? I really do not want to think of trusting a BIOS to
> >    _write to my disk_.
> 
> It's quite unlikely but I wouldn't say it's completely impossible.
> It's common for ATA controllers to have dual modes of operation - the
> old IDE compatible interface by emulation which is used by BIOS and
> older operating systems and newer interface (ahci) to be used by
> modern OS.  Some need to be explicitly switched and some just need to
> be accessed carefully.  If the controller is accessed by bIOS after
> switched to ahci or commands are in progress via ahci, anything can
> happen.

Could we read the log area, first, verify it contains signature, write
it back?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
