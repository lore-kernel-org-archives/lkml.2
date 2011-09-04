Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1IDNYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 09:24:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38176 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1IDNYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 09:24:33 -0400
Message-ID: <4E637BA8.6030300@gmail.com>
Date: Sun, 04 Sep 2011 21:22:48 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] elevator.c: use ELV_NAME_MAX instead of magic number 16 for
 chosen_elevator
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have ELV_NAME_MAX defined to 16, and hence we should use it
instead of the magic nubmer 16 for elevator's name string.

The patch is against 3.1-rc3.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 block/elevator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index a3b64bc..cb332cb 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -182,7 +182,7 @@ static void elevator_attach(struct request_queue *q, struct elevator_queue *eq,
 	eq->elevator_data = data;
 }
 
-static char chosen_elevator[16];
+static char chosen_elevator[ELV_NAME_MAX];
 
 static int __init elevator_setup(char *str)
 {
-- 
1.7.1

