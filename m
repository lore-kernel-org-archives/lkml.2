Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1K2VFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:05:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33364 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1K2VFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:05:38 -0500
MIME-Version: 1.0
In-Reply-To: <1322600301.17003.84.camel@frodo>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
 <m2r50qlmgk.fsf@firstfloor.org> <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
 <20111129203111.GQ24062@one.firstfloor.org> <CA+55aFxUFkHGXk_eEN1GYsZWe5_G9uoCP6DkL6bw9+wWP2_fcw@mail.gmail.com>
 <1322600301.17003.84.camel@frodo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Nov 2011 13:05:15 -0800
X-Google-Sender-Auth: zUiREyooIFhhMPAr6J5bzlAqZ8o
Message-ID: <CA+55aFw8cAeixca_LWJN7C5W52i7uC-WN-CdND37hvCYHVdRVw@mail.gmail.com>
Subject: Re: Perhaps a side effect regarding NMI returns
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Note, the reason that I've been looking at this code, is because I'm
> looking at implementing your idea to handle irets in NMIs, caused by
> faults, exceptions, and the reason I really care about: debugging.
>
> Your proposal is here:
>
>  https://lkml.org/lkml/2010/7/14/264

Ahh, good that you pointed to it, I'd completely forgotten about this one.

Yeah. Simplifying NMI and not mixing up the paranoid stuff sounds like
a good idea, and then if we do the nice NMI counting thing and avoid
the whole problem with NMI and iret, that would be a nice cleanup in
itself.

So if that patch I posted works for you (with some NMI-heavy workload
like non-PEBS tracing) I think it's the way to go.

Too late for 3.2 obviously, since I don't think anybody has actually
reported the "delayed NMI's" as a real problem - so even if it's a
bug, it's not a bug we should try to fix at this stage.

                      Linus
