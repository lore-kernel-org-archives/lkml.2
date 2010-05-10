Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0EJQYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:24:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43824 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab0EJQYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:24:43 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 0/4] Add a Coccinelle front-end script
Date: Mon, 10 May 2010 18:24:23 +0200
Message-Id: <1273508667-5152-1-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New targets are added (coccicheck-<mode>) to call the 'coccinelle.sh' front-end
in the 'scripts' directory with the <mode> argument.

Four modes are defined: report, patch, context, and org.

'report' mode generates a list in the following format:
  file:line:column-column: message

'patch' mode proposes a generic fix, when possible.

'context' mode highlights lines of interest and their context
in a diff-like style.

'org' mode generates a report in the Org mode format of Emacs.

Three semantic patches, with a low rate of false positives, are also
included.  Other semantic patches will be provided later. Note that a
semantic patch does not need to define all four modes. As many semantic
patches may be proposed later, they are organized under sub-directories
of 'scripts/coccinelle/'.

We add a reference to the tool in the proposed changelog because it will
make the changelog easier to understand for someone who is not aware of
the tool.

To apply a single semantic patch, the user can define the COCCI environment
variable which gives the path to the semantic patch.

Nicolas Palix (4):
  Add targets to use the Coccinelle checker
  Add scripts/coccinelle/drop_kmalloc_cast.cocci
  Add scripts/coccinelle/kzalloc-simple.cocci
  Add scripts/coccinelle/resource_size.cocci

 MAINTAINERS                                |   10 +++
 Makefile                                   |   20 +++++-
 scripts/coccinelle.sh                      |   28 ++++++++
 scripts/coccinelle/drop_kmalloc_cast.cocci |   68 ++++++++++++++++++++
 scripts/coccinelle/kzalloc-simple.cocci    |   83 ++++++++++++++++++++++++
 scripts/coccinelle/resource_size.cocci     |   94 ++++++++++++++++++++++++++++
 6 files changed, 301 insertions(+), 2 deletions(-)
 create mode 100755 scripts/coccinelle.sh
 create mode 100644 scripts/coccinelle/drop_kmalloc_cast.cocci
 create mode 100644 scripts/coccinelle/kzalloc-simple.cocci
 create mode 100644 scripts/coccinelle/resource_size.cocci

