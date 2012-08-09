Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2HIDqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 23:46:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63310 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2HIDp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 23:45:59 -0400
MIME-Version: 1.0
In-Reply-To: <1344430148.6935.17.camel@gandalf.stny.rr.com>
References: <20120807193845.146666357@goodmis.org> <20120807194059.773895870@goodmis.org>
 <5021EC6B.7020605@hitachi.com> <1344430148.6935.17.camel@gandalf.stny.rr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Aug 2012 06:45:37 +0300
X-Google-Sender-Auth: JGOU2vL6ttVmsUkAlXql-8Cdlps
Message-ID: <CA+55aFyVb5FE1t5zj7WJR3c=3PnCjwNd=UgC5eFdn5eV5PsEZw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] ftrace: Do not test frame pointers if -mfentry is used
To: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 3:49 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> No, CONFIG_HAVE_FENTRY just means fentry is supported, it does not mean
> that it is being used. It only gets used if CC_USING_FENTRY is set,
> which is set by the Makefile at time of compile.

Btw, it might be lovely to consider the concept of "Kconfig variables
set by shell-scripts".

We currently have a metric sh*t-ton of Makefile magic for testing
various things like this, and integrating it into Kconfig might be a
good idea. That way you would be able to use the Kconfig logic on
these things.

Kconfig already has the "option env=XYZ" syntax for importing values
from the environment variables. Extending it to some kind of "option
shell=xyz" would allow for more complex interactions like this
(imagine testing compiler options and version dependencies in the
Kconfig files instead of the Makefiles)?
