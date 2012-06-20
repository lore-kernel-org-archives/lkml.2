Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2FTBZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:25:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12378 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2FTBZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:25:54 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-4e-4fe1269cdb94
From: Jingoo Han <jg1.han@samsung.com>
To: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2] video: exynos_dp: fix build warning due to uninitialized
 value
Date: Wed, 20 Jun 2012 10:25:48 +0900
Message-id: <000301cd4e83$9f5fcb30$de1f6190$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1Og59H7kllzWcFSra5hn2nGxOX2w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQd05ag/9DR4s1LI40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0P57EWvCSvWLr3DcsDYw32LoYOTgkBEwkLrxw6WLk
	BDLFJC7cWw8U5uIQEpjOKLHo/E0WCOcXo8TJs28ZQarYBNQkvnw5zA7SLCJgJbFpqyZIDbNA
	G6PE+ZMzmEFqhAVCJDr+HGEBsVkEVCUudnwBs3kFbCVmnnrOCmELSvyYfA8sziygJbF+53Em
	CFteYvOat8wQx6lLPPqrCxIWEdCTmN7/lQ2iRERi34t3jBMYBWYhmTQLyaRZSCbNQtKygJFl
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwgD6T3sG4qsHiEKMAB6MSD+8Zrof+QqyJZcWV
	uYcYJTiYlUR4+7888BfiTUmsrEotyo8vKs1JLT7EKM3BoiTO22R9wV9IID2xJDU7NbUgtQgm
	y8TBKdXAOHmWr8qNb0Jmq41ftc7ofnn1gkvqB7s1/rkrw41bPl/csK/wNdt+4R1hD4KFWnXt
	F6gv9/+6d2GL0IpH2pb9Z1RT48OaHbL8e3aZ3fcO8d+z88fSxFjVmZUtZffe6W59u+hEQc8r
	hdkCXStvNYZvWhza0Cpc6L/bVjiD/fSXwq+3fhX7TJu6VImlOCPRUIu5qDgRAL1UDzxMAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes build warning due to uninitialized value dereference.

drivers/video/exynos/exynos_dp_core.c: In function 'exynos_dp_set_link_train':
drivers/video/exynos/exynos_dp_core.c:529:18: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]
drivers/video/exynos/exynos_dp_core.c:395:6: note: 'reg' was declared here

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/exynos/exynos_dp_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index a36b2d2..9db7b9f 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -407,6 +407,9 @@ static unsigned int exynos_dp_get_lane_link_training(
 	case 3:
 		reg = exynos_dp_get_lane3_link_training(dp);
 		break;
+	default:
+		WARN_ON(1);
+		return 0;
 	}
 
 	return reg;
-- 
1.7.1


