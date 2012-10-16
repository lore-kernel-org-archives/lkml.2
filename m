Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2JPF1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:27:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56545 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2JPF1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:27:54 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-8a-507cf0589738
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 1/2] regulator: core: Check before enabling regulator while
 setting constraints.
Date: Tue, 16 Oct 2012 10:54:19 +0530
Message-id: <1350365059-18838-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWyRsSkVjfiQ02Awbs/RhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj7oEO1oJZXBXXFyxib2DcztHFyMkhIWAi8WtePzOELSZx4d56
	ti5GLg4hgaWMEp/+7GCDKZq/sZMRxBYSmM4ocWtLLETRciaJ/i8tQN0cHGwCRhKvjtmB1IgI
	KEhs7n3GCmIzg9SvPFYAYgsLJEls6f0HtoxFQFVi95/lLCA2r4CrxJHdC9khdilItC47xA5R
	IyDxbfIhFpDxEgKyEpsOMIOslRDYwSaxp/cCI0S9pMTBFTdYJjAKLmBkWMUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRGFCn/z2T2sG4ssHiEKMAB6MSD2+Gc02AEGtiWXFl7iFGCQ5mJRFe
	j4lAId6UxMqq1KL8+KLSnNTiQ4w+QJdMZJYSTc4HBnteSbyhsYm5qbGppZGRmakpDmElcd5m
	j5QAIYH0xJLU7NTUgtQimHFMHJxSDYzRa9+Zls8X3xObsGjt6UCeqrUTTsoUr2uLX3wr/ZNt
	0oXo55veTtq/TeZLaKr8rLD+/ra/m34+5OP2/vY/cWqfXlyex9oHzEwCp95f2D65ZfoTDe2m
	jAJ2Ae7oPWtvLKnxZbf7lGglGH2hbOXmJZVtRYpls8uyO5o3Mjw7etSaiaVK3//0/CglluKM
	REMt5qLiRADPSNZXVQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jQd2IDzUBBs9uKltc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjLsHOlgLZnFVXF+wiL2B
	cTtHFyMnh4SAicT8jZ2MELaYxIV769lAbCGB6YwSt7bEdjFyAdnLmST6v7QwdzFycLAJGEm8
	OmYHUiMioCCxufcZK4jNDFK/8lgBiC0skCSxpfcfM4jNIqAqsfvPchYQm1fAVeLI7oXsELsU
	JFqXHWKfwMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwuD6T2sG4ssHiEKMAB6MS
	D2+Gc02AEGtiWXFl7iFGCQ5mJRFej4lAId6UxMqq1KL8+KLSnNTiQ4w+QNsnMkuJJucDYymv
	JN7Q2MTc1NjU0sTCxMwSh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsZFrV0aohwlhVtv
	HSyK52rgML1lJubae6b1m0laT9KOCY+kWn+fuB77daPL0zRZ7mdL7wa6B5g0FerkPeENvvar
	78GOvHnXWid1asl+e3fP2/iI+rpH5SJ7L99pPaMcJaBwZ++zW8d/3k5bcXEVZ+CNf3uu+xr2
	/P4167HMAfuff+JfPfmkf8dAiaU4I9FQi7moOBEADqquo4QCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds check, whether regulator is already enabled before enabling it
while setting machine constraints. Since some PMICs have same register bits
for setting opmode and enabling/disabling the regulator, so it will overwrite
the settings (if any)done by set_mode/set_suspend_mode callbacks when it
enables regulator without checking previous status.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f7c74db..9e3a0c7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -958,6 +958,9 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	 */
 	if ((rdev->constraints->always_on || rdev->constraints->boot_on) &&
 	    ops->enable) {
+		if (ops->is_enabled && ops->is_enabled(rdev))
+			goto enabled;
+
 		ret = ops->enable(rdev);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to enable\n");
@@ -965,6 +968,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
+enabled:
 	if (rdev->constraints->ramp_delay && ops->set_ramp_delay) {
 		ret = ops->set_ramp_delay(rdev, rdev->constraints->ramp_delay);
 		if (ret < 0) {
-- 
1.7.0.4

