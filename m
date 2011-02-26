Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1B1GLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:11:10 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33271 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750817Ab1B1GLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:11:07 -0500
Date: Sat, 26 Feb 2011 04:58:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: matthieu castet <castet.matthieu@free.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
Message-ID: <20110226035805.GA1656@ucw.cz>
References: <4D473FD5.1090903@free.fr>
 <20110201080223.GB20372@elte.hu>
 <1296566732.4d4809cc1f963@imp.free.fr>
 <20110202062632.GA12256@elte.hu>
 <4D4CA3FD.6000901@zytor.com>
 <1296924395.4d4d7eeb6f1fe@imp.free.fr>
 <4D4F31BC.3000709@zytor.com>
 <1297108754.4d504f1281802@imp.free.fr>
 <4D50505D.2070402@zytor.com>
 <4D56B0E6.5040600@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D56B0E6.5040600@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2011-02-12 17:10:14, matthieu castet wrote:
> H. Peter Anvin a écrit :
> >On 02/07/2011 11:59 AM, castet.matthieu@free.fr wrote:
> >>For .39 I hope we could remove most of the RWX rights after init (This means
> >>make low memory trampoline NX or !RW).
> >>This should be possible on :
> >>- 32 bit if wakeup use trampoline_32 [1] that doesn't enable paging in low
> >>memory (can be NX)
> >>- trampoline_64 need fix to support NX on data section. It tries to read data
> >>section before enabling NX. A possible fix is to use its own page table [2]. And
> >>the kernel one can be NX.
> >
> >No, you're really barking down the wrong path on this.  The trampoline
> >code is tiny; I don't think it is really worth trying to NX-ify it.  The
> Even if the trampoline is tiny, a hole is a hole.

What kind of hole are you talking about?

If evil code is running in ring0, you already lost.

I doubt you can remove all the trampolines, and I do not think you
should uglify the kernel trying to do that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
