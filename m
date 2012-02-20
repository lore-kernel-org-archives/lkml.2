Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2BTBLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:11:36 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34329 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2BTBLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:11:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.97.196 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFxqK1A0g6qHvZHxzGOTGT0YFAoRJtOeYWLxVchM=e=qww@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <12996.1329699216@neuling.org> <CA+55aFwHGUB7R6kpNPc7vDYF8dhYCKm4Riso-rpS2Fiqjg8hQg@mail.gmail.com>
 <CA+55aFxqK1A0g6qHvZHxzGOTGT0YFAoRJtOeYWLxVchM=e=qww@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 17:11:12 -0800
X-Google-Sender-Auth: nWra9r3gfCZFWHzpM5f2luDV0Ic
Message-ID: <CA+55aFwc6u6Mr9iCMKM+MexfKso4tN7D2VdWpJpuT2saj0Pgfw@mail.gmail.com>
Subject: Re: [PATCH 0/2] More i387 state save/restore work
To: Michael Neuling <mikey@neuling.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, anton@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and final comment - looking at the thing you pointed at, it looks
much more adventurous than my x86 FP state thing.

I always save things unconditionally, so that I don't have to do the
IPI or just in general care about the "oops, now I want things in
memory, not in some random CPU FP state". So mine is just a "writeback
cache", and only optimizes the reading things back: there is never any
dirty state in the CPU except when the process is actively using it.

That obviously does mean that I only optimize away the restore side,
not the save side. But it's *way* simpler, and considering that I just
spent almost a week trying to figure out FP state save bugs, simple is
good.

                  Linus
