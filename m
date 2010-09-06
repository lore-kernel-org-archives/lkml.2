Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0IFFpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:45:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:49236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0IFFpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:45:16 -0400
Date: Mon, 6 Sep 2010 05:45:15 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.10 + 2.4 EOL plans
Message-ID: <20100906054515.GA22864@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 05:45:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

This is the 10th fixup release of kernel 2.4.37. Most changes concern
relatively minor issues as well as a few medium security issues affecting
some specific areas (sctp, irda, jfs). Most likely, very few people are
concerned. The full (still short) changelog is provided at the end of this
mail.

Some of you have noticed that the last update was released 7 months ago.
This is long, but these days, very few of the issues reported on 2.6 also
affect 2.4, so basically the number of bug reports on 2.4 fades out quite
fast. Also, I generally prefer not to release a kernel just for a single
non-critical patch, especially if we consider that 2.4 users generally
wait a few weeks to a few months before upgrading. Since quite a bunch of
fixes started to pile up, I thought it was time to release a new one.

I've realized that I only have a few 2.4-based systems left in production,
and that my other systems are now running fine with long-term supported
2.6.27 and 2.6.32 kernels. At my company, we're still shipping our load
balancers with a 2.4 kernel, but we're considering upgrading to 2.6 for a
next release, so even there I won't have many reasons to work on 2.4. All
these clues should ring a bell for those of you still relying on 2.4...

So what I'm planning to do for next releases is to automatically stop
providing updates one year after the last update. What this means is that
if there are important fixes to merge, they will shift the end of support
date for one new year, but if nothing important happens during one whole
year, that proves the code is stable enough to fly by itself, and you don't
need any update anymore. This is not a rigid rule though and I still decide
whether something has to be fixed or not. If I collect some non-important
patches, I'll queue them up but not emit a release for them. If something
critical happens, then I'll emit a new release. If that happens after one
year of silence, it is possible that I'll still emit a release, without
shifting the end of life date further.

So I'm releasing 2.4.37.10 here. If nothing happens before September 2011,
it's possible that there won't be any 2.4.37.11 at all. By that time, the
2.6 kernel will have been available for almost 8 years, this should have
been enough for anyone to have a look at it. Users now have one year to
migrate or to report critical bugs. I think that's a honnest deal. After
all, if users are able to report critical bugs for 5 years so that I have
to maintain it for that long, at least I'm doing it for a good reason, so
that's not a problem for me.

There's no need to hurry, but the upgrade should seriously be considered.

At one point, I envisaged to start a 2.4.38 with a bunch of updated drivers.
Now I'd prefer that the users migrate to 2.6. However, I do have a good set
of updated/backported drivers available (my own kernels boot on about every
hardware I find today), so if some users are interested, I'll take some time
to put the updates online.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.10.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.10

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git


Summary of changes from v2.4.37.9 to v2.4.37.10
============================================

Dave Kleikamp (1):
      jfs: don't allow os2 xattr namespace overlap with others

Neil Horman (1):
      sctp: Fix skb_over_panic resulting from multiple invalid parameter errors (CVE-2010-1173) (v4)

Pavel Emelyanov (1):
      irda: Sock leak on error path in irda_create.

Stefan Seyfried (1):
      FAT: do not continue in fat_get_block if bmap fails

Sylvain Rochet (2):
      drivers/tun: MTU change for TUN/TAP interfaces
      net: permanent NUD pins ethernet interfaces when ATM is compiled in.

Wei Yongjun (2):
      sctp: fix to calc the INIT/INIT-ACK chunk length correctly is set
      SCTP: Fix to encode PROTOCOL VIOLATION error cause correctly

Willy Tarreau (2):
      irda: correctly free memory on irda_bind() failure
      Change VERSION to 2.4.37.10

