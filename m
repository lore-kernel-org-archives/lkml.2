Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1B0Vg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:36:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:42194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1B0Vgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:36:49 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: trenn@suse.de, lenb@kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: [PATCH] intel_idle: Rename cpuidle states
Date: Sun, 27 Feb 2011 22:36:43 +0100
Message-Id: <1298842606-55712-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298842606-55712-1-git-send-email-trenn@suse.de>
References: <1298842606-55712-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace apps might have to cut off parts off the
idle state name for display reasons.
Switch NHM-C1 to C1-NHM (and others) so that a cut off
name is unique and makes sense to the user.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: lenb@kernel.org
---
 drivers/idle/intel_idle.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 1fa091e..de6d0c5 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -100,7 +100,7 @@ static struct cpuidle_state *cpuidle_state_table;
 static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
-		.name = "NHM-C1",
+		.name = "C1-NHM",
 		.desc = "MWAIT 0x00",
 		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
@@ -108,7 +108,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.target_residency = 6,
 		.enter = &intel_idle },
 	{ /* MWAIT C2 */
-		.name = "NHM-C3",
+		.name = "C3-NHM",
 		.desc = "MWAIT 0x10",
 		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -116,7 +116,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.target_residency = 80,
 		.enter = &intel_idle },
 	{ /* MWAIT C3 */
-		.name = "NHM-C6",
+		.name = "C6-NHM",
 		.desc = "MWAIT 0x20",
 		.driver_data = (void *) 0x20,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -128,7 +128,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
-		.name = "SNB-C1",
+		.name = "C1-SNB",
 		.desc = "MWAIT 0x00",
 		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
@@ -136,7 +136,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.target_residency = 1,
 		.enter = &intel_idle },
 	{ /* MWAIT C2 */
-		.name = "SNB-C3",
+		.name = "C3-SNB",
 		.desc = "MWAIT 0x10",
 		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -144,7 +144,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.target_residency = 211,
 		.enter = &intel_idle },
 	{ /* MWAIT C3 */
-		.name = "SNB-C6",
+		.name = "C6-SNB",
 		.desc = "MWAIT 0x20",
 		.driver_data = (void *) 0x20,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -152,7 +152,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.target_residency = 345,
 		.enter = &intel_idle },
 	{ /* MWAIT C4 */
-		.name = "SNB-C7",
+		.name = "C7-SNB",
 		.desc = "MWAIT 0x30",
 		.driver_data = (void *) 0x30,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -164,7 +164,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
-		.name = "ATM-C1",
+		.name = "C1-ATM",
 		.desc = "MWAIT 0x00",
 		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
@@ -172,7 +172,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.target_residency = 4,
 		.enter = &intel_idle },
 	{ /* MWAIT C2 */
-		.name = "ATM-C2",
+		.name = "C2-ATM",
 		.desc = "MWAIT 0x10",
 		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
@@ -181,7 +181,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 	{ /* MWAIT C3 */ },
 	{ /* MWAIT C4 */
-		.name = "ATM-C4",
+		.name = "C4-ATM",
 		.desc = "MWAIT 0x30",
 		.driver_data = (void *) 0x30,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -190,7 +190,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 	{ /* MWAIT C5 */ },
 	{ /* MWAIT C6 */
-		.name = "ATM-C6",
+		.name = "C6-ATM",
 		.desc = "MWAIT 0x52",
 		.driver_data = (void *) 0x52,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
-- 
1.7.3.4

