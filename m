Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1EXKzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:55:40 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:39520 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761Ab1EXKzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:55:39 -0400
Date: Tue, 24 May 2011 12:51:47 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richard.cochran@omicron.at>, linux-kernel@vger.kernel.org
Subject: [PATCH] posix clocks: correct error value in posix_clock_poll()
Message-ID: <20110524125147.0eb112b5@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
It looks to me like -ENODEV might not be a good return value
in poll(). Would POLLERR be the correct one in this case?

 kernel/time/posix-clock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index c340ca6..2424d3f 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -71,7 +71,7 @@ static unsigned int posix_clock_poll(struct file *fp, poll_table *wait)
 	int result = 0;
 
 	if (!clk)
-		return -ENODEV;
+		return POLLERR;
 
 	if (clk->ops.poll)
 		result = clk->ops.poll(clk, fp, wait);
-- 
1.7.5.rc3
