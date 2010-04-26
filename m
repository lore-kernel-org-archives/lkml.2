Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0DZVLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:11:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50049 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab0DZVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:11:53 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, Nicolas Palix <npalix@diku.dk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk
Subject: [PATCH 0/4] Add a Coccinelle front-end script
Date: Mon, 26 Apr 2010 23:11:15 +0200
Message-Id: <1272316279-12042-1-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New targets are added (coccicheck-<mode>) to call the spatch front-end
in the 'scripts' directory with the <mode> argument.

Four modes are defined: report, patch, context, and org.

'report' mode generates a list in the following format:
  file:line:column-column: message

'patch' mode proposes a generic fix, when possible.

'context' mode highlights lines of interest and their context
in a diff-like style.

'org' mode generates a report in the Org mode format of Emacs.

Three semantic patches, with a low rate of false positives, are also added.
Other semantic patches will be propose later.

Nicolas Palix (4):
  Add targets to use the Coccinelle checker
  Add scripts/smpl/drop_kmalloc_cast.cocci
  Add scripts/smpl/kzalloc-simple.cocci
  Add scripts/smpl/resource_size.cocci

 MAINTAINERS                          |   10 +++
 Makefile                             |    9 +++
 scripts/smpl/drop_kmalloc_cast.cocci |   74 +++++++++++++++++++++++++
 scripts/smpl/kzalloc-simple.cocci    |   88 +++++++++++++++++++++++++++++
 scripts/smpl/resource_size.cocci     |  101 ++++++++++++++++++++++++++++++++++
 scripts/spatch.sh                    |   14 +++++
 6 files changed, 296 insertions(+), 0 deletions(-)
 create mode 100644 scripts/smpl/drop_kmalloc_cast.cocci
 create mode 100644 scripts/smpl/kzalloc-simple.cocci
 create mode 100644 scripts/smpl/resource_size.cocci
 create mode 100755 scripts/spatch.sh

