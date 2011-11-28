Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1K1PYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:24:38 -0500
Received: from postman.teamix.net ([194.150.191.120]:59864 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291Ab1K1PYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:24:38 -0500
From: Martin Steigerwald <ms@teamix.de>
Organization: teamix GmbH
To: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] Mention that the util-linux package provides an ionice  command.
Date: Mon, 28 Nov 2011 16:24:33 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-686-pae; KDE/4.6.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
References: <201111281542.22258.ms@teamix.de>
In-Reply-To: <201111281542.22258.ms@teamix.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201111281624.34217.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. November 2011 schrieb Martin Steigerwald:
> Hi jens und Vivek,
> 
> Vivek, I cc'd you, cause you wrote the new cfq-iosched.txt.
> 
> 
> In trying to understand how I/O priorities actually really work, I tried to
> dd with
> 
> rm nullen-id ; sync ; /usr/bin/time ionice -c3 dd if=/dev/zero of=nullen-id
> count=500 bs=1M conv=fsync
> 
> versus
> 
> rm nullen-rl; sync ; /usr/bin/time ionice -c1 -n0 dd if=/dev/zero
> of=nullen-rl count=500 bs=1M conv=fsync
> 
> concurrently. No differences. At first I was puzzled, then I thought maybe
> direct I/O makes a difference. So I tried with oflag=direct.
> 
> And it does.
> 
> Then I actually read the documentation block/ioprio.txt (3.1 here):
> > With the introduction of cfq v3 (aka cfq-ts or time sliced cfq), basic io
> > priorities are supported for reads on files.  This enables users to io
> > nice processes or process groups, similar to what has been possible with
> > cpu scheduling for ages.  This document mainly details the current
> > possibilities with cfq; other io schedulers do not support io priorities
> > thus far.
> 
> According to it I/O priorities will even only work on reads. Is that
> correct? I mean they do work on reads, I tested it, but *only* on reads?
> 
> From what I see here, it also works for direct I/O write requests
> 
> So from what I conclude is that CFQ I/O priorities work for all requests
> that are issued via synchronous system calls, but not for those issued via
> asynchronous calls, i. e. everything that goes through the pagecache.
> 
> Is that correct?
> 
> 
> Vivek, one thing on cfq-iosched.txt: Could slice_idle=0 make sense on SSDs?
> Later on you write that there are some SSD optimizations in place that cut
> down idling already.

And mentioned that ionice is available from the util-linux package:


>From 182d2e06d65ea784c2bbf2e756ce0452fdebef8c Mon Sep 17 00:00:00 2001
From: Martin Steigerwald <ms@teamix.de>
Date: Mon, 28 Nov 2011 16:16:33 +0100
Subject: [PATCH 3/3] Mention that the util-linux package provides an ionice
 command.

---
 Documentation/block/ioprio.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/block/ioprio.txt b/Documentation/block/ioprio.txt
index 4775a95..5b79a29 100644
--- a/Documentation/block/ioprio.txt
+++ b/Documentation/block/ioprio.txt
@@ -58,6 +58,9 @@ For a running process, you can give the pid instead:
 
 will change pid 100 to run at the realtime scheduling class, at priority 2.
 
+The util-linux package includes an ionice command that basically works like
+described here.
+
 ---> snip ionice.c tool <---
 
 #include <stdio.h>
-- 
1.7.7.3

Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
