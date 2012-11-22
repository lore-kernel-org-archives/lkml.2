Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2KVUEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:04:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60172 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2KVUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:03:57 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ec-50adda0dc48b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 0/3] charger-manager: Bug fix and split _probe function
Date: Thu, 22 Nov 2012 16:53:41 +0900
Message-id: <1353570821-19369-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zHV3eW2sDDO7elrK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZHy89YS/4zVJx9twSpgbGFpYuRk4OCQETiatPf7JC2GISF+6t
	Z+ti5OIQEljGKPF15gZ2mKKb27+wQiSmM0r092+HcpYyScw50QvWziagJbH/xQ02EFtEQE7i
	9dq/TCA2s0CtxL5rTWA1wgJeEht+XweLswioSiybsxVsA6+Aq8Th6yuZILYpSLQuO8QOUSMg
	8W3yIaBTOYDishKbDjCD7JUQ2MImMfvaYTaIekmJgytusExgFFzAyLCKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIySopHYwrmywOMQowMGoxMOr6bw2QIg1say4MvcQowQHs5II76ICoBBv
	SmJlVWpRfnxRaU5q8SFGH6BLJjJLiSbnAwM+ryTe0NjA2NDQ0tDM1NLUAIewkjhvs0dKgJBA
	emJJanZqakFqEcw4Jg5OqQZGM/NXXEkiExgOJjGeeL5p47XzYg8eWf7+rv8w4synjI0O9vMW
	2t9ev7k9rPnOlzypore+8pfk1u5gj7/8j+lj2+fpdSa+lkzLLHq37vx6cJulcEg+y4K6ye2f
	3ySo2hWkPIyeNe3m2muRkt937am9dUAzvmyO5AkBkawOtz3FO26IBIn8nSjnoMRSnJFoqMVc
	VJwIACAWkONXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQV3eW2sDDLZ9ELC4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGR8vPWEv+M1ScfbcEqYG
	xhaWLkZODgkBE4mb27+wQthiEhfurWfrYuTiEBKYzijR37+dFcJZyiQx50QvWBWbgJbE/hc3
	2EBsEQE5iddr/zKB2MwCtRL7rjWB1QgLeEls+H0dLM4ioCqxbM5WdhCbV8BV4vD1lUwQ2xQk
	WpcdYp/AyL2AkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDIPpPawbiyweIQowAHoxIP
	r6bz2gAh1sSy4srcQ4wSHMxKIryLCoBCvCmJlVWpRfnxRaU5qcWHGH2Atk9klhJNzgfGU15J
	vKGxiZmRpZGZsYm5sTEOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjJ07b+gnpQnHGsUs
	9tTccXZTrYF4J5edfmam0Ow9B4quT6vKefLth9GWi10p1df3SW805HJvWBTKn992eF6cyeMv
	Nx1af3IfMlvL//JAZOcTji0GFdcuXHUK3xxke/f+Cl/t9rt1AU7feJ+sd1u8Lrd+p/Nhk5mt
	f8K8kn9Ybs6Y0uQo1t/7XomlOCPRUIu5qDgRACnjlQSGAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset include bug fix patch and code clean to split _probe function
because _probe function is longer than 400 line.

Dear Anton,
The previous patchset is sent from wrong email address because I'm mistake.
Please ignore previous patchset.

Chanwoo Choi (3):
  charger-manager: Fix bug related to checking fully charged state of
    battery
  charger-manager: Fix bug when check dropped voltage after fullbatt
    event
  charger-manager: Split _probe funtion for code clean

 drivers/power/charger-manager.c |  321 +++++++++++++++++++++++----------------
 1 files changed, 187 insertions(+), 134 deletions(-)

