Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0KJIxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:53:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab0KJIxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:53:31 -0500
Date: Wed, 10 Nov 2010 09:53:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Marcus Meissner <meissner@suse.de>,
        linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101110085314.GB8370@elte.hu>
References: <20101104100914.GC25118@suse.de>
 <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <871v6xt3l1.fsf@basil.nowhere.org>
 <a4676065-571a-4dda-bd3a-798a9b2d7edf@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4676065-571a-4dda-bd3a-798a9b2d7edf@email.android.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> We already do virtual relocation on 32 bits, and replicating that on 64 bits 
> wouldn't be hard.  However, the linkage script strongly assumes congruency mod 2/4 
> MiB, and that is probably nontrivial to change.  However, that still gives about 9 
> bits of entrophy to play with.  The question is if that is enough, or if we'd have 
> to do more clever hacks.

Even 1 bit of entropy would bring a visible improvement: a failed exploit attempt to 
the wrong address can crash the kernel with a 50% chance. 9 bits would be very nice.

If an exploit can be brute-forced without crashing the kernel then only some 
significantly large bitness would help. So while 9 bits would be rather low for a 
user-space ASLR scheme [many user-space bugs can be brute-forced without crashing 
the system and raising alarms], it's very attractive for kernel ASLR.

	Ingo
