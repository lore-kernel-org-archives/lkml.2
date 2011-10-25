Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1JYDpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 23:45:10 -0400
Received: from ozlabs.org ([203.10.76.45]:46269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1JYDpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 23:45:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Michal Schmidt <mschmidt@redhat.com>
Subject: [PULL] module and param
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 25 Oct 2011 14:13:59 +1030
Message-ID: <87mxcppwg0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Via github, returning to kernel.org is on my TODO list...)

The following changes since commit 1bf1aacedcda23c75e70fa3394e1caa6d4b5ee49:

  Merge branch 'samsung-fixes-4' of git://github.com/kgene/linux-samsung (2011-10-23 10:44:40 +0300)

are available in the git repository at:

  git://github.com/rustyrussell/linux.git master

Jiri Kosina (1):
      kmod: prevent kmod_loop_msg overflow in __request_module()

Michal Schmidt (1):
      params: make dashes and underscores in parameter names truly equal

 include/linux/moduleparam.h |   20 ++++++++++++++++++++
 init/main.c                 |    4 ++--
 kernel/kmod.c               |    4 +++-
 kernel/params.c             |   21 ++++++++++++++-------
 4 files changed, 39 insertions(+), 10 deletions(-)

commit ea1c71de56fb2799da9d6f26778c7ddf5f42c4a3
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Tue Oct 25 11:53:31 2011 +1030

    kmod: prevent kmod_loop_msg overflow in __request_module()
    
    Due to post-increment in condition of kmod_loop_msg in __request_module(),
    the system log can be spammed by much more than 5 instances of the 'runaway
    loop' message if the number of events triggering it makes the kmod_loop_msg
    to overflow.
    
    Fix that by making sure we never increment it past the threshold.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    CC: stable@kernel.org

 kernel/kmod.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

commit 14377d658e711ef2301db023370aeaa48a466401
Author: Michal Schmidt <mschmidt@redhat.com>
Date:   Mon Oct 10 00:03:37 2011 +0200

    params: make dashes and underscores in parameter names truly equal
    
    The user may use "foo-bar" for a kernel parameter defined as "foo_bar".
    Make sure it works the other way around too.
    
    Apply the equality of dashes and underscores on early_params and __setup
    params as well.
    
    The example given in Documentation/kernel-parameters.txt indicates that
    this is the intended behaviour.
    
    With the patch the kernel accepts "log-buf-len=1M" as expected.
    https://bugzilla.redhat.com/show_bug.cgi?id=744545
    
    Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (neatened implementations)

 include/linux/moduleparam.h |   20 ++++++++++++++++++++
 init/main.c                 |    4 ++--
 kernel/params.c             |   21 ++++++++++++++-------
 3 files changed, 36 insertions(+), 9 deletions(-)
