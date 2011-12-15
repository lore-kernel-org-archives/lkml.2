Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab1LOND1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:03:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1LOND0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:03:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix a cast to pointer from integer of different size warning
 in intel_idle
To: lenb@kernel.org, deepthi@linux.vnet.ibm.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 15 Dec 2011 13:03:14 +0000
Message-ID: <20111215130314.4804.78941.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:

drivers/idle/intel_idle.c: In function 'intel_idle_cpuidle_devices_init':
drivers/idle/intel_idle.c:518:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

By making get_driver_data() return a long instead of an int.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d2f8e1..4304e24 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -197,7 +197,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
-static int get_driver_data(int cstate)
+static long get_driver_data(int cstate)
 {
 	int driver_data;
 	switch (cstate) {

