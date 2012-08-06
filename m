Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2HFEpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:45:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18049 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2HFEpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:45:35 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-17-501f4bee2404
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Claudio Nieder'" <private@claudio.ch>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 3/3] backlight: kb3886: Use usleep_range() instead of msleep()
 for small sleeps
Date: Mon, 06 Aug 2012 13:45:34 +0900
Message-id: <002e01cd738e$50fcfdc0$f2f6f940$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zjlDmRmqBTkVHQuK0rw+1xUDefQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd133vIBBn9XaVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mex3vGQums1fcmrOPuYFxAlsXIyeHhICJxIHt/xghbDGJC/fW
	A8W5OIQEpjNKPH81nwXCmc0k8XT5Y3aQKjYBNYkvXw6D2SICERLNM2Yxg9jMAqUSTx7tAIsL
	CyRKfGudAxZnEVCVeLx4L1MXIwcHr4CtxIk5OiBhXgFBiR+T77FAtGpJbN7WxAphy0tsXvOW
	GaRcQkBd4tFfXYhNehL7W9+yQ5SISOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECA7LZ1I7GFc2WBxiFOBgVOLhvWkgHyDEmlhWXJl7iFGCg1lJ
	hDfdWS5AiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+x91d/IYH0xJLU7NTUgtQimCwTB6dUA2MO
	c9hKh1e8r1jSV/HKOx0LPLnZ7MjFaUp189ZtmejT7Pxsj//DTG55/vwuvYZDM4W8uLl6JmS2
	r++fKOqvdG/T/5Ltt1Yevn1npvzRtw8nzPHi+eV54rjUW99tZ77NP2pa5bnftmUO74l48Zv2
	G98+8Vn58KcIU/u8tx5KQd12qyPaVfsZYgKUWIozEg21mIuKEwEhf/9HRwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since msleep might not sleep for the desired amount when less
than 20ms, use usleep_range.

Cc: Claudio Nieder <private@claudio.ch>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/kb3886_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index 72dd555..6c5ed6b 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -34,9 +34,9 @@ static void kb3886_bl_set_intensity(int intensity)
 	mutex_lock(&bl_mutex);
 	intensity = intensity&0xff;
 	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
-	msleep(10);
+	usleep_range(10000, 11000);
 	outb(KB3886_PWM0_WRITE, KB3886_IO);
-	msleep(10);
+	usleep_range(10000, 11000);
 	outb(intensity, KB3886_IO);
 	mutex_unlock(&bl_mutex);
 }
-- 
1.7.1


