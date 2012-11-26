Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2KZIfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:35:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60949 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2KZIfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:35:34 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-77-50b329d201f0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, "'Marek Vasut'" <marex@denx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: lms283gf05: use GPIOF_INIT flags when using
 devm_gpio_request_one()
Date: Mon, 26 Nov 2012 17:35:29 +0900
Message-id: <004501cdcbb0$fdeddfc0$f9c99f40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3LsP2dWBuP426kSMqTDhoNyIBmQA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zY91LmpsDDD51cllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mzt5tjAUPOCo6t5k2MM5i72Lk5JAQMJH4s3cHK4QtJnHh3nq2
	LkYuDiGBZYwSp26dYoUpmn5qJyNEYjqjxOp1q5kgnNlMEt+/TWcEqWITUJP48uUw2FgRgQiJ
	5hmzmEFsZoFcia7jf8FsYYFEidMnZoBNZRFQlXjR+BVoEAcHr4CtxM4lmSBhXgFBiR+T77FA
	tGpJrN95nAnClpfYvOYtM0i5hIC6xKO/uhCb9CQa181nhygRkdj34h0jxHQBiW+TD7FAlMtK
	bDrADPFKO7vEh35nCFtS4uCKGywTGMVmIVk8C8niWUgWz0KyYQEjyypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2MkCiR2sG4ssHiEKMAB6MSD2/hiU0BQqyJZcWVuYcYJTiYlUR4JzIBhXhT
	EiurUovy44tKc1KLDzH6AB0+kVlKNDkfGMF5JfGGxsYmZiamJuaWpuamOISVxHmbPVIChATS
	E0tSs1NTC1KLYMYxcXBKNTDOi3bSbPK/dsh1S41ZQYDrtSqm35pnXRlZ16/fZbZE59nTqymT
	+XsjTCa5mgfOL5Be4tjjUXd9U8F3m+N+nrt8X3+41PKicrLm8pzXp/zM9f/1hrLy7Uh45N01
	pfLd4nKnh8XzjzSvbd14942YvfeJmWZLzqyepj0hzszvp1r1QZW5oYuiL0YrsRRnJBpqMRcV
	JwIAU63Qe78CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd1LmpsDDCZvZbW4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGZ292xgLHnBUdG4zbWCc
	xd7FyMkhIWAiMf3UTkYIW0ziwr31bF2MXBxCAtMZJVavW80E4cxmkvj+bTpYFZuAmsSXL4fB
	ukUEIiSaZ8xiBrGZBXIluo7/BbOFBRIlTp+YwQpiswioSrxo/Ao0iIODV8BWYueSTJAwr4Cg
	xI/J91ggWrUk1u88zgRhy0tsXvOWGaRcQkBd4tFfXYhNehKN6+azQ5SISOx78Y5xAqPALCST
	ZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7CZ1I7GFc2WBxiFOBg
	VOLhLTyxKUCINbGsuDL3EKMEB7OSCO9EJqAQb0piZVVqUX58UWlOavEhRh+gPycyS4km5wMT
	RF5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjBpLuG+zxywU
	Uenw2+o6zYm1eBvT1Y0Lrr/pUuio3Gg9y+ahZu0cHmmpu4etZpqlpy4TeRj6duPc155tf34+
	V4qLeKwaqT5zc85PmXUrtVO0XnNveO/1SEKmeXEpq4Gm8dMIq4mTTGZtWfLhYs6NxRzzvfN0
	pq1/9vOK7MuJlwUVPBwivYu+ViuxFGckGmoxFxUnAgAaX3Kb7wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIOF_DIR_OUT and GPIOF_DIR_IN are defined as below:
 GPIOF_DIR_OUT   (0 << 0)
 GPIOF_DIR_IN    (1 << 0)
So, when !pdata->reset_inverted is 1, the gpio pin can be set as
input, instead of output.

To provent this problem, GPIOF_INIT flag should be used when
using devm_gpio_request_one().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/lms283gf05.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index d317730..3dc4995 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -159,7 +159,8 @@ static int __devinit lms283gf05_probe(struct spi_device *spi)
 
 	if (pdata != NULL) {
 		ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
-				GPIOF_DIR_OUT | !pdata->reset_inverted,
+				GPIOF_DIR_OUT | (!pdata->reset_inverted ?
+				GPIOF_INIT_HIGH : GPIOF_INIT_LOW),
 				"LMS285GF05 RESET");
 		if (ret)
 			return ret;
-- 
1.7.2.5


