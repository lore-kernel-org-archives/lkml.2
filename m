Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2DSARK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:17:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2DSARJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:17:09 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 0/5] RFC: x86: Early exception table support
Date: Wed, 18 Apr 2012 17:16:45 -0700
Message-Id: <1334794610-5546-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 17:16:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we get an exception during early boot, walk the exception table to
see if we should intercept it.  The main use case for this is to allow
rdmsr_safe()/wrmsr_safe() during CPU initialization.

Since the exception table is currently sorted at runtime, and fairly
late in startup, this code walks the exception table linearly.  We
obviously don't need to worry about modules, however: none have been
loaded at this point.

In the future it would be better to have the table sorted at compile
time, or even better, turned into a perfect hash.  At that point this
code should be changed out from doing a linear search.

This patchset also makes the early exception handling a little more
similar between x86-64 and i386, but a lot of unification could (and
should) still be done: in particular, setup done in C as in x86-64,
and verbose error dump as in i386.
