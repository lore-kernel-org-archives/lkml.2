Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2BAXrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:47:05 -0500
Received: from tundra.namei.org ([65.99.196.166]:56796 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab2BAXrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:47:03 -0500
Date: Thu, 2 Feb 2012 10:47:00 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Fixes for MPI library (updated)
In-Reply-To: <alpine.LRH.2.00.1202020037340.20463@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.1202021045210.24321@tundra.namei.org>
References: <alpine.LRH.2.00.1202020037340.20463@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from for-linus2 instead of per the previous request.  Since 
then, I've applied DaveM's patches, too.


The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
  Linus Torvalds (1):
        Linux 3.3-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus2

David Miller (2):
      lib: Fix multiple definitions of clz_tab
      lib: Fix 32-bit sparc udiv_qrnnd() definition in mpilib's longlong.h

Dmitry Kasatkin (11):
      lib/mpi: added missing NULL check
      lib/mpi: replaced MPI_NULL with normal NULL
      lib/mpi: return error code on dividing by zero
      lib/mpi: checks for zero divisor length
      lib/mpi: removed unused functions
      lib/digsig: additional sanity checks against badly formated key payload
      lib/digsig: pkcs_1_v1_5_decode_emsa cleanup
      lib/mpi: check for possible zero length
      lib/mpi: added comment on divide by 0 case
      lib/mpi: added missing NULL check
      lib/digsig: checks for NULL return value

 arch/sparc/Kconfig      |    1 +
 arch/sparc/lib/divdi3.S |   16 +--------
 include/linux/mpi.h     |    2 -
 lib/Kconfig             |    4 ++
 lib/Makefile            |    2 +
 lib/clz_tab.c           |   18 +++++++++
 lib/digsig.c            |   52 ++++++++++++---------------
 lib/mpi/longlong.h      |   44 +++++++++++++++++------
 lib/mpi/mpi-bit.c       |   19 ----------
 lib/mpi/mpi-div.c       |    5 +++
 lib/mpi/mpi-pow.c       |    2 +-
 lib/mpi/mpicoder.c      |   91 +---------------------------------------------
 lib/mpi/mpih-div.c      |    4 ++
 lib/mpi/mpiutil.c       |    5 ++-
 14 files changed, 98 insertions(+), 167 deletions(-)
 create mode 100644 lib/clz_tab.c
