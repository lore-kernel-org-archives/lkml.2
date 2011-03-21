Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1CVAAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:00:00 -0400
Received: from kroah.org ([198.145.64.141]:48994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab1CUXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:52 2011
Message-Id: <20110321231052.295989662@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:09:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [15/44] x86, quirk: Fix SB600 revision check
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 1d3e09a304e6c4e004ca06356578b171e8735d3c upstream.

Commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
(x86 quirk: Fix polarity for IRQ0 pin2 override on SB800
systems) introduced a regression. It removed some SB600 specific
code to determine the revision ID without adapting a
corresponding revision ID check for SB600.

See this mail thread:

  http://marc.info/?l=linux-kernel&m=129980296006380&w=2

This patch adapts the corresponding check to cover all SB600
revisions.

Tested-by: Wang Lei <f3d27b@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110315143137.GD29499@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/early-quirks.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -161,7 +161,12 @@ static void __init ati_bugs_contd(int nu
 	if (rev >= 0x40)
 		acpi_fix_pin2_polarity = 1;
 
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	if (acpi_use_timer_override)


