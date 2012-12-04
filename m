Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2LDFPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 00:15:46 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47352 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2LDFPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 00:15:44 -0500
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 00:15:42 -0500
Message-ID: <CAPgLHd9xtF36732aozVOupf4cyF0RxgSncRzAxF=3WhGV779cw@mail.gmail.com>
Subject: [PATCH -next] Drivers: hv: remove unused variable in vmbus_recvpacket_raw()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: yongjun_wei@trendmicro.com.cn, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable userlen is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hv/channel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 773a2f2..3148d80 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -774,7 +774,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 {
 	struct vmpacket_descriptor desc;
 	u32 packetlen;
-	u32 userlen;
 	int ret;
 
 	*buffer_actual_len = 0;
@@ -788,7 +787,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 
 
 	packetlen = desc.len8 << 3;
-	userlen = packetlen - (desc.offset8 << 3);
 
 	*buffer_actual_len = packetlen;
 

