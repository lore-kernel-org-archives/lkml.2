Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0EaMAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:00:21 -0400
Received: from ozlabs.org ([203.10.76.45]:41135 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab0EaMAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:00:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Subject: [PATCH 0/2] kernel/module.c locking changes
Date: Mon, 31 May 2010 21:30:15 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <201005252300.07739.rjw@sisk.pl> <20100527184602.GF7351@jenkins.ifup.org> <201005311910.32407.rusty@rustcorp.com.au>
In-Reply-To: <201005311910.32407.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005312130.17038.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In response to Linus' almost-rational dislike of the lock-drop-and-regrab
patch, I've dug out and updated the fine-grained locking patch for module.c.
Simple testing here seems to work, and it might have a good effect on boot
times too (its original target).

Pull request for those who find that easier:

The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
  Linus Torvalds (1):
        Linux 2.6.35-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6.git modules

Rusty Russell (3):
      module: fix reference to mod->percpu after freeing module.
      module: make locking more fine-grained.
      module: fix bne2 "gave up waiting for init of module libcrc32c"

 kernel/module.c |  151 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 98 insertions(+), 53 deletions(-)

