Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1E0GMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:12:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab1E0GMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:12:21 -0400
Date: Fri, 27 May 2011 08:12:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 vdso updates
Message-ID: <20110527061208.GB9260@elte.hu>
References: <alpine.LFD.2.02.1105262049180.3078@ionos>
 <4DDEC589.3010201@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDEC589.3010201@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@mit.edu> wrote:

> On 05/26/2011 02:50 PM, Thomas Gleixner wrote:
> >       x86-64: Add time to vDSO
> 
> And here's the glibc bug:
> 
> http://sourceware.org/bugzilla/show_bug.cgi?id=12813
> 
> Let the deprecation of the vsyscall page begin :)

Yeah :-)

On a related note, now that these bits are upstream, what are your 
rough plans for doing the int81 vsyscall emulation patch?

The int81 patch would actually be (much!) more important to the 
average Linux user than getting rid of the vsyscall from static 
binaries: the vsyscall is the last predictable executable address in 
PIE daemons with a dangerous SYSENTER instruction in it ...

I'd actually consider accelerating it into v2.6.40.

Thanks,

	Ingo
