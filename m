Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab1HOUFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:05:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36712 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1HOUFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:05:15 -0400
Date: Mon, 15 Aug 2011 22:05:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Lutomirski <luto@mit.edu>
Cc: melwyn lobo <linux.melwyn@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Subject: Re: x86 memcpy performance
Message-ID: <20110815200510.GA10141@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Lutomirski <luto@mit.edu>,
	melwyn lobo <linux.melwyn@gmail.com>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
 <4E493449.70907@mit.edu>
 <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
 <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com>
 <9022c7d6f1724a37245fd744c8c16140.squirrel@www.skyhub.de>
 <CAObL_7ExSmbucefJ386LhK9UccVn5wKRvxHdLq0j__5bG2apwA@mail.gmail.com>
 <3175fc05afa1c2b0defd935d0fec22d5.squirrel@www.skyhub.de>
 <CAObL_7HPssPSaMMKdc-9LFKQXUnreFxMy4g8g2b7KdiRkBPW7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAObL_7HPssPSaMMKdc-9LFKQXUnreFxMy4g8g2b7KdiRkBPW7w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 03:11:40PM -0400, Andrew Lutomirski wrote:
> > Well, copy_from_user... does a bunch of rep; movsq - if the SSE version
> > shows reasonable speedup there, we might need to make those work too.
> 
> I'm a little surprised that SSE beats fast string operations, but I
> guess benchmarking always wins.

If by fast string operations you mean X86_FEATURE_ERMS, then that's
Intel-only and that actually would need to be benchmarked separately.
Currently, I see speedup for large(r) buffers only vs rep; movsq. But I
dunno about rep; movsb's enhanced rep string tricks Intel does.

> Yes.  But we don't nest that much, and the save/restore isn't all that
> expensive.  And we don't have to save/restore unless kernel entries
> nest and both entries try to use kernel_fpu_begin at the same time.

Yep.

> This whole project may take awhile.  The code in there is a
> poorly-documented mess, even after Hans' cleanups.  (It's a lot worse
> without them, though.)

Oh yeah, this code could use lotsa scrubbing :)

-- 
Regards/Gruss,
    Boris.
