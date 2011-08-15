Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1HOUIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:08:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38847 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1HOUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110815200510.GA10141@liondog.tnic>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
 <4E493449.70907@mit.edu> <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
 <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com>
 <9022c7d6f1724a37245fd744c8c16140.squirrel@www.skyhub.de> <CAObL_7ExSmbucefJ386LhK9UccVn5wKRvxHdLq0j__5bG2apwA@mail.gmail.com>
 <3175fc05afa1c2b0defd935d0fec22d5.squirrel@www.skyhub.de> <CAObL_7HPssPSaMMKdc-9LFKQXUnreFxMy4g8g2b7KdiRkBPW7w@mail.gmail.com>
 <20110815200510.GA10141@liondog.tnic>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 15 Aug 2011 16:08:19 -0400
X-Google-Sender-Auth: utwEbb-m_8u0nM8KViv3u3acQ18
Message-ID: <CAObL_7HMTDE5hYBs_C2esuOExOvK1akhxvn4MCaUyK6vPTmHJg@mail.gmail.com>
Subject: Re: x86 memcpy performance
To: Borislav Petkov <bp@alien8.de>, Andrew Lutomirski <luto@mit.edu>,
        melwyn lobo <linux.melwyn@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 4:05 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Aug 15, 2011 at 03:11:40PM -0400, Andrew Lutomirski wrote:
>> > Well, copy_from_user... does a bunch of rep; movsq - if the SSE version
>> > shows reasonable speedup there, we might need to make those work too.
>>
>> I'm a little surprised that SSE beats fast string operations, but I
>> guess benchmarking always wins.
>
> If by fast string operations you mean X86_FEATURE_ERMS, then that's
> Intel-only and that actually would need to be benchmarked separately.
> Currently, I see speedup for large(r) buffers only vs rep; movsq. But I
> dunno about rep; movsb's enhanced rep string tricks Intel does.

I meant X86_FEATURE_REP_GOOD.  (That may also be Intel-only, but it
sounds like rep;movsq might move whole cachelines on cpus at least a
few generations back.)  I don't know if any ERMS cpus exist yet.
