Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab0FGJJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:09:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60122 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab0FGJJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:09:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Marek <mmarek@suse.cz>
Subject: [kbuild regression, post-rc1] Remote installation over read-only NFS broken
Date: Mon, 7 Jun 2010 11:10:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006071110.26245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Unfortunately, your commit 73d1393eb8507ed5fd7f8e696f6b1ecc18035ebe
(kbuild: Generate modules.builtin in make modules_install) broke my testing
environment that had always worked before.

Namely, I build kernels on a central machine and export the build directory
along with the kernel sources over read-only NFS to test boxes.  Then, on the
test boxes I run "make modules_install", copy the kernel to /boot, run mkinitrd
and so on.  Now, after your commit above the "make modules_install" command on
the test boxes doesn't work any more, because it tries to write to the build
directory, which is mounted read-only.

Please fix or revert.

Rafael
