Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2GXMBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:01:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab2GXMBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:01:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL 00/15] arm-soc: changes for v3.6
Date: Tue, 24 Jul 2012 12:00:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        linux-kernel@vger.kernel.org, "Mark A. Greer" <mgreer@animalcreek.com>,
        arm@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
References: <1343075561-17446-1-git-send-email-arnd@arndb.de> <201207240751.39111.arnd@arndb.de> <20120724081246.GS6522@atomide.com>
In-Reply-To: <20120724081246.GS6522@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241200.11190.arnd@arndb.de>
X-Provags-ID: V02:K0:EBl1YfV2v1tUPyLqNptoAKIST1vmE20Zd84EBKsp6xs
 KVgKrjkr5uQNbWy7tIUdOVBIzHdHjpGbqDtu52tpsektI2Itf+
 39VPiOeAjstaNa9NLPH1zkjW/5FPQaYOq/xVnQBICNL+M0Vqhu
 lvwYYS/axsd1Di87zSQXW2bHlx95qybcyBudRRpc45nOayI0xO
 l0ZR2ECz3fVgkfRd7r1wBLg70rvDAj5Vy8e+LdbkgpHI1ZuQrd
 S6p11eWWBqxl0R7kVyIh5jIJXU2usI4tmNhVvB24tR+zoGhFm6
 nIynIx8fYpldo/V9uZGvxsN74DFqkDrdICWGXJbEs1LX9dYQ25
 0fIDksH4DN/IPan419+0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012, Tony Lindgren wrote:
> > I spent too much time fiddling with my scripts again in an attempt to
> > get closer to the regular git-request-pull version. The older version
> > got this right, but unfortunately I removed the part where I manually
> > print the right pull address because that had caused other problems
> > before.
> 
> FYI, this issue happens also with git request-pull if the tag has not
> yet gotten mirrored but the branch is already mirrored.

In this case it they were both there, but it picked up the branch
anyway. I actually made sure that the tag description was included
by git-request-pull, and the tag has a different name from the
branch (no "next/" prefix), but the tool is not does not attempt
to pick up the tag rather than the branch when both are available.

Apparently, the problem is that it treats the branch "next/foo"
as as exact match for a pull request on the "foo" tag even when
that tag is present as "foo" on the server. If I either name the
branch or the tag differently, or pass "tags/foo" as the
argument to git-request-pull, it reports back the tag instead.

	Arnd
