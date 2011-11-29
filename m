Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1K2UNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:13:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36003 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab1K2UNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <m2r50qlmgk.fsf@firstfloor.org>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
 <m2r50qlmgk.fsf@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Nov 2011 12:12:44 -0800
X-Google-Sender-Auth: l2yBlkkHWhg1N2xKPcCxkkN7rJk
Message-ID: <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
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

On Tue, Nov 29, 2011 at 12:09 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Not sure what problem Steven thinks is there. Once you
> switched the stack any nesting is fine.

The problem is that NMI's are blocked!

We're potentially switching to another process, there is no guarantee
there will be an "iret" *anywhere* in any patch for a long time. So
any subsequent NMI's will not be able to come in.

> The reason I added them originally is to prevent the race of remote
> kernel events being delayed for a long time. With Frederic's nohz work
> this will be more important in the future. Today it would be eventually
> picked up by the regular timer interrupts.

You're just delaying another kind of event: the next NMI.

And NMI's really shouldn't be triggering any scheduling-related events afaik.

                Linus
