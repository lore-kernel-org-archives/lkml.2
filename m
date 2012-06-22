Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762740Ab2FVVek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:34:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2FVVeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:34:37 -0400
Date: Fri, 22 Jun 2012 14:34:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rob Landley <rob@landley.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Doug Ledford <dledford@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] fs: introduce pipe-only dump mode suid_dumpable=3
Message-Id: <20120622143435.c1ba744e.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jLMRc3svVuPznUkUEcF2HOHRE_6b5bmL-Aiw7FtsN6zHw@mail.gmail.com>
References: <20120622192413.GA5774@www.outflux.net>
	<20120622125551.269552c2.akpm@linux-foundation.org>
	<CAGXu5jLMRc3svVuPznUkUEcF2HOHRE_6b5bmL-Aiw7FtsN6zHw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 14:09:28 -0700
Kees Cook <keescook@chromium.org> wrote:

> On Fri, Jun 22, 2012 at 12:55 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Fri, 22 Jun 2012 12:24:13 -0700
> > Kees Cook <keescook@chromium.org> wrote:
> >
> >> The value
> >> of suid_dumpable=2 is now historic, and attempting to set this sysctl
> >> value returns -EINVAL.
> >
> > This sounds a bit harsh - will it not cause existing configurations to
> > immediately break? __If so, would it not be better to retain the =2 mode
> > for a while, and emit a nice warning when it is set?
> 
> I view it as a security vulnerability, so I'd rather see it
> eliminated. I see "=1" as a security vulnerability too, but at least
> that's well-known to be a bad idea. The "=2" mode has been assumed to
> be safe, but it isn't.

But what will be the effects of the change?  People's initscripts do an
"echo 2" which fails and the error message (if any) won't get logged
anywhere where anyone looks.  So now their machine is bumbling along in
the wrong mode and much later on, someone notices that coredumps are
going awry?  This is not exactly a user-friendly way of rolling out
kernel API changes!

And how serious is the security vulnerability, in real-world terms? 
Serious enough to risk this amount of bustage?

