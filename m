Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161181Ab1FAIHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:07:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:43076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146Ab1FAIHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:07:14 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:36 2011
Message-Id: <20110601080236.258795167@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:07 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milton Miller <miltonm@bga.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [011/146] powerpc/kdump64: Dont reference freed memory as pacas
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milton Miller <miltonm@bga.com>

commit bd9e5eefecb3d69018bb95796298019d309cbec8 upstream.

Starting with 1426d5a3bd07589534286375998c0c8c6fdc5260 (powerpc:
Dynamically allocate pacas) the space for pacas beyond cpu_possible
is freed, but we failed to update the loop in crash.c.

Since c1854e00727f50f7ac99e98d26ece04c087ef785 (powerpc: Set nr_cpu_ids
early and use it to free PACAs) the number of pacas allocated is
always nr_cpu_ids.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -170,7 +170,7 @@ static void crash_kexec_wait_realmode(in
 	int i;
 
 	msecs = 10000;
-	for (i=0; i < NR_CPUS && msecs > 0; i++) {
+	for (i=0; i < nr_cpu_ids && msecs > 0; i++) {
 		if (i == cpu)
 			continue;
 


