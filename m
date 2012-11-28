Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2K1AsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:48:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35555 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2K1AsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:48:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a0-50b55f52fb86
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>
References: 
In-reply-to: 
Subject: [PATCH 1/2] thermal: exynos: Check the range of temperature code
Date: Wed, 28 Nov 2012 09:48:17 +0900
Message-id: <001201cdcd02$0e5f55d0$2b1e0170$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QA04GwQA+GV/4ABkgZKcA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI92g+K0BBo/es1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MT8f2sxbc56r4uP0ncwNjP3sXIyeHhICJxL6ZU1ghbDGJC/fW
	s3UxcnEICSxjlLj2egobTNHCB0eYQWwhgemMEjNOqUDY85gkjs+zArHZBHQljq3fAjZIRCBa
	4k/jHmaQQcwCTYwSR1vnAW3jAGrglljdHARSwynAI7HuTyfYTGEBT4lz098xgtgsAqoSE87u
	BYvzCthJrJswHcoWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIOMlBNQlHv3VhTjBSWLRidWs
	ECUiEvtewIwXkPg2+RALRLmsxKYDYFdKCMxjl1i97RYzxLuSEgdX3GCZwCgxC8nmWUg2z0Ky
	eRaSFQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525ihMSV9A7GVQ0WhxgFOBiVeHgdHLcG
	CLEmlhVX5h5ilOBgVhLhTYsECvGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MObzSuINjY1N
	zExMTcwtTc1NcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamCUeXFH6Z6Ax33xlVK3nLJK
	ExYw/jNd/VXnUL/E9D1PSv4WpHTPT9uz72pUYsyjcMvuhXeP9NtPOSHSlGGy6fo1D+3Ml4sk
	txvohp1vniEbZxm9+u76+OJbbi95sjVXvFJYcJxpSfnESE63/PRJVteYWy2YDz7WfpvTPOuo
	UeE7bkvtyw/6v39SYinOSDTUYi4qTgQAsEieHdgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd2g+K0BBp0zGS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqdj+1kL7nNVfNz+k7mB
	sZ+9i5GTQ0LARGLhgyPMELaYxIV769lAbCGB6YwSM06pQNjzmCSOz7MCsdkEdCWOrd/CCmKL
	CERL/GncA9TLxcEs0MQocbR1HtBQDqAGbonVzUEgNZwCPBLr/nSCzRcW8JQ4N/0dI4jNIqAq
	MeHsXrA4r4CdxLoJ06FsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDDJeQkBd4tFfXYgTnCQW
	nVjNClEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85
	P3cTIzhqn0nvYFzVYHGIUYCDUYmH18Fxa4AQa2JZcWXuIUYJDmYlEd60SKAQb0piZVVqUX58
	UWlOavEhRh+gRycyS4km5wMTSl5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAhgfTEktTs1NSC
	1CKYcUwcnFINjKlS8UpZp9T1v4p83Sgebz/vhoq5TPbxiXVix/03T1753qLpC3e0tj1bSvvl
	u0UKNw4sSHJ9eK4zpLu0nO9q4Pa8l08UkyYE6W+Or8tUbjxUd/Ht8fflwZ5vfRlcY19pi/t9
	Klrx99KmY6uScqTkZu5RW/Onkks689MZjXnKZlc2feDpn/ueXYmlOCPRUIu5qDgRAFQXus8H	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The temperature code should range between 46 and 146.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index 6dd29e4..dc2ad6c 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -530,14 +530,21 @@ out:
 static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 {
        struct exynos_tmu_platform_data *pdata = data->pdata;
-       int temp;
+       int min, max, temp;

-       if (data->soc == SOC_ARCH_EXYNOS4210)
-               /* temp_code should range between 75 and 175 */
-               if (temp_code < 75 || temp_code > 175) {
-                       temp = -ENODATA;
-                       goto out;
-               }
+       if (data->soc == SOC_ARCH_EXYNOS4210) {
+               min = 75;
+               max = 175;
+       } else {
+               min = 46;
+               max = 146;
+       }
+
+       /* temp_code should range between min and max */
+       if (temp_code < min || temp_code > max) {
+               temp = -ENODATA;
+               goto out;
+       }

        switch (pdata->cal_type) {
        case TYPE_TWO_POINT_TRIMMING:
--
1.7.4.1

