Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab0J1W3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:29:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:40140 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0J1W3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:29:45 -0400
Date: Fri, 29 Oct 2010 00:29:42 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas.Palix@inria.fr, amwang@redhat.com, dick@streefland.net,
        julia@diku.dk, mfm@muteddisk.com, mmarek@suse.cz, namhyung@gmail.com,
        npalix.work@gmail.com, npalix@diku.dk, shemminger@vyatta.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for 2.6.37-rc1
Message-ID: <20101028222942.GA1852@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these assorted kbuild updates for 2.6.37-rc1:
* make coccicheck updates
* kbuild documentation improved
* scripts/namespace.pl (make namespacecheck) fixes
* scripts/extract-ikconfig support for bzip2, lzma and lzo-compressed
  kernels
* small fix for scripts/basic/docproc, which is the reason why I merged
  v2.6.36, because the code to be fixed went via another tree in the
  rc phase.

Michal

The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git misc

Amerigo Wang (3):
      scripts/namespace.pl: fix wrong source path
      scripts/namespace.pl: some bug fixes
      scripts/namespace.pl: improve to get more correct results

Dick Streefland (1):
      scripts/extract-ikconfig: add support for bzip2, lzma and lzo

Julia Lawall (2):
      Coccinelle: Find nested lock+irqsave functions that use the same flags variables.
      Coccinelle: Find doubled arguments to boolean or bit operators.

Michal Marek (2):
      Merge commit 'v2.6.36' into kbuild/misc
      Revert "namespace: add source file location exceptions"

Namhyung Kim (1):
      kbuild: check return value of asprintf()

Nicolas Palix (26):
      Coccinelle: Add null/eno.cocci
      Coccinelle: Add null/kmerr.cocci
      Coccinelle: Move deref_null.cocci to a more appropriate directory
      Coccinelle: Add locks/call_kern.cocci
      Coccinelle: Add locks/double_lock.cocci
      Coccinelle: Add locks/mini_lock.cocci
      Coccinelle: Add iterators/fen.cocci
      Coccinelle: Add iterators/itnull.cocci
      Coccinelle: Add iterators/list_entry_update.cocci
      Coccinelle: Add free/kfree.cocci
      Coccinelle: Add api/kstrdup.cocci
      Coccinelle: Add api/memdup.cocci
      Coccinelle: Add api/memdup_user
      Coccinelle: Move err_cast.cocci to the api directory
      Coccinelle: Move resource_size.cocci to the api directory
      Coccinelle: Move alloc directory into api directory
      Coccinelle: Add misc/doubleinit.cocci
      Coccinelle: Add misc/ifcol.cocci
      MAINTAINERS: Coccinelle: Update email address
      Coccinelle: Update documentation
      Coccinelle: Improve user information with a new kind of comment
      Coccinelle: Use new comment format to explain kfree.cocci
      Coccinelle: Add a new mode named 'chain'
      Coccinelle: Use the -no_show_diff option for org and report mode
      Coccinelle: Fix documentation
      Coccinelle: Add contextual message

Stephen Hemminger (2):
      scripts/namespace.pl: update file exclusion list
      namespace: add source file location exceptions

matt mooney (3):
      Documentation/kbuild: major edit of modules.txt sections 1-4
      Documentation/kbuild: major edit of modules.txt sections 5-8
      Documentation/kbuild: modules.txt cleanup

 Documentation/coccinelle.txt                       |   50 +-
 Documentation/kbuild/modules.txt                   |  733 ++++++++++----------
 MAINTAINERS                                        |    2 +-
 scripts/basic/docproc.c                            |    5 +-
 scripts/coccicheck                                 |   46 +-
 .../{ => api}/alloc/drop_kmalloc_cast.cocci        |    0
 .../{ => api}/alloc/kzalloc-simple.cocci           |    6 +-
 scripts/coccinelle/{ => api}/err_cast.cocci        |    0
 scripts/coccinelle/api/kstrdup.cocci               |   39 +
 scripts/coccinelle/api/memdup.cocci                |   40 ++
 scripts/coccinelle/api/memdup_user.cocci           |   35 +
 scripts/coccinelle/{ => api}/resource_size.cocci   |    0
 scripts/coccinelle/free/kfree.cocci                |  117 ++++
 scripts/coccinelle/iterators/fen.cocci             |   64 ++
 scripts/coccinelle/iterators/itnull.cocci          |   58 ++
 .../coccinelle/iterators/list_entry_update.cocci   |   62 ++
 scripts/coccinelle/locks/call_kern.cocci           |   74 ++
 scripts/coccinelle/locks/double_lock.cocci         |   92 +++
 scripts/coccinelle/locks/flags.cocci               |   80 +++
 scripts/coccinelle/locks/mini_lock.cocci           |   95 +++
 scripts/coccinelle/misc/doubleinit.cocci           |   53 ++
 scripts/coccinelle/misc/ifcol.cocci                |   48 ++
 scripts/coccinelle/{ => null}/deref_null.cocci     |    0
 scripts/coccinelle/null/eno.cocci                  |   20 +
 scripts/coccinelle/null/kmerr.cocci                |   72 ++
 scripts/coccinelle/tests/doublebitand.cocci        |   54 ++
 scripts/coccinelle/tests/doubletest.cocci          |   40 ++
 scripts/extract-ikconfig                           |   41 +-
 scripts/namespace.pl                               |  147 +++--
 29 files changed, 1597 insertions(+), 476 deletions(-)
 rename scripts/coccinelle/{ => api}/alloc/drop_kmalloc_cast.cocci (100%)
 rename scripts/coccinelle/{ => api}/alloc/kzalloc-simple.cocci (87%)
 rename scripts/coccinelle/{ => api}/err_cast.cocci (100%)
 create mode 100644 scripts/coccinelle/api/kstrdup.cocci
 create mode 100644 scripts/coccinelle/api/memdup.cocci
 create mode 100644 scripts/coccinelle/api/memdup_user.cocci
 rename scripts/coccinelle/{ => api}/resource_size.cocci (100%)
 create mode 100644 scripts/coccinelle/free/kfree.cocci
 create mode 100644 scripts/coccinelle/iterators/fen.cocci
 create mode 100644 scripts/coccinelle/iterators/itnull.cocci
 create mode 100644 scripts/coccinelle/iterators/list_entry_update.cocci
 create mode 100644 scripts/coccinelle/locks/call_kern.cocci
 create mode 100644 scripts/coccinelle/locks/double_lock.cocci
 create mode 100644 scripts/coccinelle/locks/flags.cocci
 create mode 100644 scripts/coccinelle/locks/mini_lock.cocci
 create mode 100644 scripts/coccinelle/misc/doubleinit.cocci
 create mode 100644 scripts/coccinelle/misc/ifcol.cocci
 rename scripts/coccinelle/{ => null}/deref_null.cocci (100%)
 create mode 100644 scripts/coccinelle/null/eno.cocci
 create mode 100644 scripts/coccinelle/null/kmerr.cocci
 create mode 100644 scripts/coccinelle/tests/doublebitand.cocci
 create mode 100644 scripts/coccinelle/tests/doubletest.cocci
