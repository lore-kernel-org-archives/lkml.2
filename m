Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1K2Ugi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:36:38 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60074 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1K2Ugh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:36:37 -0500
MIME-Version: 1.0
In-Reply-To: <20111129203111.GQ24062@one.firstfloor.org>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
 <m2r50qlmgk.fsf@firstfloor.org> <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
 <20111129203111.GQ24062@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Nov 2011 12:36:14 -0800
X-Google-Sender-Auth: fg0O7M21d-UqoV2LhadeXXCw1nU
Message-ID: <CA+55aFxUFkHGXk_eEN1GYsZWe5_G9uoCP6DkL6bw9+wWP2_fcw@mail.gmail.com>
Subject: Re: Perhaps a side effect regarding NMI returns
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:31 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> As a simple fix your proposal of forcing IRET sounds good.

We could of course use iret to return to the regular kernel stack, and
do the schedule from there.

So instead of doing the manual stack switch, just build a fake iret
stack on our exception stack. Subtle and somewhat complicated. I'd
almost rather just do a blind iret, and leave the 'iret to regular
stack' as a possible future option.

                       Linus
