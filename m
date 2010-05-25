Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab0EYU7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:59:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab0EYU7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:59:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Regression] Crash in load_module() while freeing args
Date: Tue, 25 May 2010 23:00:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005252300.07739.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recent -git kernels crash for me quite often during boot, reporting that kernel
paging request could not be satisfied at load_module+0x18e4, which
corresponds to line 2483 of kernel/module.c for the kernel in question (however
the same call trace says IP is at precpu_modfree+0x1 at the moment of the
crash, which seems to point to line 2481 of the same file).  It doesn't happen
every time, but it does happen often enough to be annoying and the call
trace is always exactly the same.

I'm going to revert post-2.6.34 commits that touch kernel/module.c directly
and see what happens.

Thanks,
Rafael
