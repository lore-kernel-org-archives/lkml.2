Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2HADlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 23:41:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54631 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2HADlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 23:41:24 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Jul 2012 21:41:03 -0600
X-Google-Sender-Auth: E-xjn0T7UrmgXOyK2EeDJGfFnr8
Message-ID: <CACxGe6sEa0r71KOcSZmZRrVNKvo9etrJEG+2fUEbrEfMCi2NtA@mail.gmail.com>
Subject: [GIT PULL] irqdomain changes for v3.6
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the irqdomain changes I've got queued up. I held off sending
this pull request due to a late discovered bug and I wanted to give it
some extra time in linux-next. All should be good now. Please pull.

g.

The following changes since commit bdc0077af574800d24318b6945cf2344e8dbb050:

  Merge tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2012-07-24
18:11:22 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/irqdomain-for-linus

for you to fetch changes up to f5a1ad057e6da5d0fc9c5677ff44797d193d3e62:

  irqdomain: Improve diagnostics when a domain mapping fails
(2012-07-24 22:37:30 -0600)

----------------------------------------------------------------
irqdomain changes for Linux v3.6

Round of refactoring and enhancements to irq_domain infrastructure. This
series starts the process of simplifying irqdomain. The ultimate goal is
to merge LEGACY, LINEAR and TREE mappings into a single system, but had
to back off from that after some last minute bugs. Instead it mainly
reorganizes the code and ensures that the reverse map gets populated
when the irq is mapped instead of the first time it is looked up.

Merging of the irq_domain types is deferred to v3.7

In other news, this series adds helpers for creating static mappings on
a linear or tree mapping.

----------------------------------------------------------------
Dong Aisheng (1):
      irq_domain: correct a minor wrong comment for linear revmap

Grant Likely (11):
      devicetree: add helper inline for retrieving a node's full name
      irqdomain: Remove unnecessary test for IRQ_DOMAIN_MAP_LEGACY
      irqdomain: Make ops->map hook optional
      Merge tag 'v3.5-rc6' into irqdomain/next
      irqdomain: Split disassociating code into separate function
      irqdomain: Always update revmap when setting up a virq
      irqdomain: Support for static IRQ mapping and association.
      irqdomain: Eliminate dedicated radix lookup functions
      irqdomain: Fix irq_create_direct_mapping() to test irq_domain type.
      Merge remote-tracking branch 'origin' into irqdomain/next
      irqdomain: eliminate slow-path revmap lookups

Mark Brown (2):
      irq_domain: Standardise legacy/linear domain selection
      irqdomain: Improve diagnostics when a domain mapping fails

Paul Mundt (1):
      irqdomain: Simple NUMA awareness.

 Documentation/IRQ-domain.txt           |    5 +
 arch/powerpc/sysdev/xics/icp-hv.c      |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c  |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c |    3 -
 include/linux/irqdomain.h              |   28 ++-
 include/linux/of.h                     |   15 +-
 kernel/irq/irqdomain.c                 |  362 ++++++++++++++++++--------------
 7 files changed, 248 insertions(+), 169 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
