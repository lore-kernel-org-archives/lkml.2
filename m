Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0FEBuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 21:50:09 -0400
Received: from ozlabs.org ([203.10.76.45]:49952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab0FEBuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 21:50:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Sat, 5 Jun 2010 11:19:58 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006041450.37611.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006041547140.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006041547140.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006051119.59842.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 08:18:13 am Linus Torvalds wrote:
> Can you send me a pointer to the safe/bugfix part, and I'll pull it for 
> -rc2? I'd like to do that Saturday.

Yep, here it is:

The following changes since commit ad8456361fa19068cf49b50a4f98e41b73c08e76:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jgarzik/libata-dev

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Linus Torvalds (2):
      module: Make the 'usage' lists be two-way
      module: move find_module check to end

Rusty Russell (6):
      module: fix kdb's illicit use of struct module_use.
      module: move sysfs exposure to end of load_module
      module: Make module sysfs functions private.
      module: make locking more fine-grained.
      module: verify_export_symbols under the lock
      module: fix bne2 "gave up waiting for init of module libcrc32c"

 include/linux/module.h      |   44 ++-----
 kernel/debug/kdb/kdb_main.c |   12 +--
 kernel/module.c             |  320 ++++++++++++++++++++++++++++---------------
 3 files changed, 221 insertions(+), 155 deletions(-)
