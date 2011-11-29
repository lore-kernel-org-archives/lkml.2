Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1K2V27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:28:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48371 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1K2V24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:28:56 -0500
Date: Tue, 29 Nov 2011 22:28:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Subject: Re: Perhaps a side effect regarding NMI returns
Message-ID: <20111129212855.GR24062@one.firstfloor.org>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com> <m2r50qlmgk.fsf@firstfloor.org> <1322598920.17003.71.camel@frodo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322598920.17003.71.camel@frodo>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm curious to what remote events can be set by an NMI that wont take
> affect in what the NMI interrupted. I would think that NMIs should be
> treated as if they didn't exist, because they should not be calling
> anything that sets NEED_RESCHED or grabbing locks and such.

Hmm, i thought there were cases where we checked if it was in
kernel mode instead of IPIng, and assume the check is done when
returning.

But cannot come up with a concrete example right now. It may have
been wrong. Or I forgot it :)

You're right anything with interrupts should be fine because
it's just blocked.

-Andi

