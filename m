Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1LRXyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:54:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1LRXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:54:09 -0500
Date: Sun, 18 Dec 2011 15:53:51 -0800
From: tip-bot for Michael Demeter <michael.demeter@intel.com>
Message-ID: <tip-d79a8869d8a4b565b12a88faeff834b09a36368c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        michael.demeter@intel.com, hpa@zytor.com, mingo@redhat.com,
        kirill.shutemov@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, michael.demeter@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        kirill.shutemov@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111215223116.10166.50803.stgit@bob.linux.org.uk>
References: <20111215223116.10166.50803.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/mrst:
  Add additional debug prints for pb_keys
Git-Commit-ID: d79a8869d8a4b565b12a88faeff834b09a36368c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 18 Dec 2011 15:53:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d79a8869d8a4b565b12a88faeff834b09a36368c
Gitweb:     http://git.kernel.org/tip/d79a8869d8a4b565b12a88faeff834b09a36368c
Author:     Michael Demeter <michael.demeter@intel.com>
AuthorDate: Thu, 15 Dec 2011 22:31:23 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 18 Dec 2011 09:37:07 +0100

x86/mrst: Add additional debug prints for pb_keys

Added additional debug output that we always seem to add
during power ons to validate firmware operation.

Signed-off-by: Michael Demeter <michael.demeter@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20111215223116.10166.50803.stgit@bob.linux.org.uk
[ fixed line breaks, formatting and commit title. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/mrst/mrst.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 6a21f60..b6a33d2 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -983,6 +983,7 @@ static int __init pb_keys_init(void)
 	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
 	for (i = 0; i < num; i++) {
 		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc, gb[i].gpio);
 		if (gb[i].gpio == -1)
 			continue;
 
