Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2FSGg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:36:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35621 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2FSGg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:36:27 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-7f-4fe01de9587a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] video: exynos_dp: fix build warning due to uninitialized value
Date: Tue, 19 Jun 2012 15:36:25 +0900
Message-id: <001501cd4de5$d955a290$8c00e7b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1N5dkBHVU3yfqETPOiSDamjvPRTQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQd2Xsg/8DXpeylmc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmnL7MXnCPvWJN7zrGBsaLbF2MnBwSAiYSU16eZ4Kw
	xSQu3FsPFOfiEBKYziixZ8dmRgjnF6PE3Ck9rCBVbAJqEl++HGbvYuTgEBGwkti0VROkhlmg
	jVHi/MkZzCA1wgL+EjsfbASbyiKgKjF10RuwbbwCthIPV9xih7AFJX5MvscCYjMLaEms33mc
	CcKWl9i85i0zyHwJAXWJR391IVbpSXxZbA1RISKx78U7xgmMArOQDJqFZNAsJINmIWlZwMiy
	ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4QJ9J7WBc2WBxiFGAg1GJh1dA6oG/EGtiWXFl
	7iFGCQ5mJRHeVf/v+wvxpiRWVqUW5ccXleakFh9ilOZgURLnbbK+4C8kkJ5YkpqdmlqQWgST
	ZeLglGpgVKjQUMhpNj8pu1Vg+UT75mt/Cs6sDDu2cIKAnrGET4kbr9DZxU82RSh9cPDP032x
	dsn74n8r9376IcwuYpn4fMVctWjPNgbhbvuNi8oE3/KfY2vcufMUm+GEDzPaKptDb2pfyX61
	o8EnKffhpEsHL/nd2FG38aaSY86nkzPWdBz5OOvjjztekkosxRmJhlrMRcWJAIUzmjBMAgAA
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
 drivers/video/exynos/exynos_dp_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index a36b2d2..9b2cdff 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -407,6 +407,8 @@ static unsigned int exynos_dp_get_lane_link_training(
 	case 3:
 		reg = exynos_dp_get_lane3_link_training(dp);
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return reg;
-- 
1.7.1


