Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1DOVdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:33:35 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34212 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757256Ab1DOVdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:33:33 -0400
Date: Fri, 15 Apr 2011 23:33:32 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC] Remove CVS keywords from tree
Message-ID: <20110415213332.GA19648@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to get the CVS keywords removed from the tree? The $Id$
tags and friends are no longer used since we moved to git.
The problem is that CVS still can be used. Let me explain. Belive it or
not, there there are still people out there that *are* checking the linux
kernel source code into CVS before they start work. The chosen one is
then confronted with a lot of changes once he compares the "origin" with
the "update-archive".
Some of the changes can be taken care of by -w. What is left can be
grouped into a) real changes and b) updated CVS keywords. I'm sick of
the latter.
So I made a script. Two to be exact. The first [0] removes $Id$ and
friends from tree. $Revision$ is sometimes replaced by _Revision_gone_.
This is done because some of them are used as variables, defines or
something else and I can't automaticly remove them. They will be
replaced manually in a second step. I understand if someone wants to
know the revision/version of a driver via dmesg in a bug report but the
kernel version that is used is more accurate than this stale
information.
The second script [1] removes $Log$ keywords. Those are a little special
because the commit message is always appended. So it gets rid of the
complete log message(s). I don't see the point of keeping them since we
have git log for this purpose and those messages are also no longer
updated.

So. The result of the first script can be seen in [2] and of the second
in [3]. Once both are applied, diffstat will say:

 660 files changed, 321 insertions(+), 2020 deletions(-)

Please excuse that I don't attach anything to the email I'm writting but
the patches will probably hang in the mail filter and don't know to
attach two files inline.

After breaking the ice, is there someone who needs those keywords still
in tree?

[0] http://download.breakpoint.cc/cvs/strip-cvs-id-tags.sed
[1] http://download.breakpoint.cc/cvs/strip-log.py
[2] http://download.breakpoint.cc/cvs/0001-remove-ID.patch
[3] http://download.breakpoint.cc/cvs/0002-remove-LOG.patch

Sebastian
