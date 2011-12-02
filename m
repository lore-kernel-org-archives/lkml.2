Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab1LBWr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:47:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52531 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1LBWr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:47:57 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1320712291.git.luto@amacapital.net>
References: <CALCETrXAiHs9PyziHBm-gZRiyahYafbxxUSxJUcFh=a-0th0EQ@mail.gmail.com>
 <cover.1320712291.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 2 Dec 2011 14:47:35 -0800
Message-ID: <CALCETrVxHvH61D-xY6vq4ymWXAVOdj8=XV_ENqLQUJ5rMieuEg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix and re-enable vsyscall=emulate
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 4:33 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> The really nice fix (wiring up access_ok failures to be able to raise
> signals) won't be ready on time for 3.2, so let's try the simpler fix
> for now.

I spoke to hpa about this a couple days ago, and he pointed out a
problem with making access_ok send signals.  Userspace expects signals
that come with full context information to be restartable, and many
system calls are not restartable.  read() and write() are the obvious
examples: once they're processed the beginning of the buffer, unless
they adjust their parameters, they can't safely be restarted.  So
without massive changes, I think allowing access_ok to raise a signal
with full context is asking for trouble.

I can still do the patch with two modes: signals without context via
arch_prctl and signals with context via vsyscall emulation, but that's
probably overkill for fixing this bug.  I'd say just apply these
patches as is (for 3.3).

--Andy
