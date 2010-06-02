Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0FBGfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:35:43 -0400
Received: from ozlabs.org ([203.10.76.45]:53579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab0FBGfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:35:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 16:05:36 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1006012039570.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006012137390.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006012137390.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021605.38817.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 02:14:37 pm Linus Torvalds wrote:
> (That function _really_ should be peeled like an onion, and split into 
> many smaller functions, so that we don't have ten error cases needing 
> unwinding. I like "goto error", but at some point you can't see the 
> unwinding any more, and that function has passed that point a long time 
> ago, I think)

Agreed.  Feel free to take a stab at it if you're bored.  Last I tried,
there wasn't an obvious split point which actually reduced the size of the
function.

And here's the tree I'm testing now (it compiles, currently rebasing to
dodge some unrelated -rc1 fs/block weirdness):

The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
  Linus Torvalds (1):
        Linux 2.6.35-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 modules

Eric Dumazet (1):
      module: module_unload_init() cleanup

Linus Torvalds (2):
      module: Make the 'usage' lists be two-way
      module: move find_module check to end

Rusty Russell (6):
      module: fix reference to mod->percpu after freeing module.
      module: fix kdb's illicit use of struct module_use.
      module: move sysfs exposure to end of load_module
      module: Make module sysfs functions private.
      module: make locking more fine-grained.
      module: fix bne2 "gave up waiting for init of module libcrc32c"

 include/linux/module.h      |   44 ++-----
 kernel/debug/kdb/kdb_main.c |   12 +--
 kernel/module.c             |  325 ++++++++++++++++++++++++++++---------------
 3 files changed, 226 insertions(+), 155 deletions(-)
