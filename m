Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2C1GmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:42:05 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:49116 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab2C1GmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:42:04 -0400
Date: Wed, 28 Mar 2012 08:41:57 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: padata: Fixes for 3.4
Message-ID: <20120328064157.GD16191@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Mar 2012 06:41:57.0811 (UTC) FILETIME=[DF41A830:01CD0CAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the following changes:

1) Add a reference to the padata api documentation to the code.
   Suggested by Peter Zijlstra.

2) We use the active cpumask to determine the superset of cpus
   to use for parallelization. The active cpumask is not the appropriate
   cpumask for these purposes. Replace the cpu active usage by cpu online.
   Reported by Peter Zijlstra.

3)  On cpu hotplug, we don't remove the cpu that went offline from our cpumasks.
    Fix this by removing this cpu from the padata cpumasks.

Please pull or apply.

The patchset is based on the crypto-2.6 tree and is available via git:

The following changes since commit ff0a70fe053614e763eb3ac88bfea9c5615fce3b:
  Jussi Kivilinna (1):
        crypto: twofish-x86_64-3way - module init/exit functions should be static

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/linux-stk padata-fixes

Steffen Klassert (3):
      padata: Add a reference to the api documentation
      padata: Use the online cpumask as the default
      padata: Fix cpu hotplug

 kernel/padata.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)
