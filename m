Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0KHKNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:13:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0KHKNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:13:08 -0500
From: Bernhard Walle <walle@corscience.de>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: gpio: Clarify usage of poll(2)
Date: Mon,  8 Nov 2010 11:12:56 +0100
Message-Id: <1289211176-9094-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:llIGHF+LYgr05azJOZAP0BBZUduvWHiNDJuHZ2CQZWw
 CV2W7BuXtYEh9cYnA3f27GKXQJ+tuzIpTtfZmJStBKATx43GgR
 2BZRWVb/2mIFVzfzG4pPbXiKE1fG0bbiQuYm8Bn06h37w9AT4D
 i18qddI6/39oXQlMCZtdSgu/loKVlEpi39VfmXpgYwqQarCycY
 vOj7hBRaojUD55uVLyI6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bit more information how to use poll(2) on GPIO value files
correctly. For me it was not clear that I need to poll(2) for
POLLPRI|POLLERR or select(2) for exceptfds.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 Documentation/gpio.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 9633da0..792faa3 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -617,6 +617,16 @@ and have the following read/write attributes:
 		is configured as an output, this value may be written;
 		any nonzero value is treated as high.
 
+		If the pin can be configured as interrupt-generating interrupt
+		and if it has been configured to generate interrupts (see the
+		description of "edge"), you can poll(2) on that file and
+		poll(2) will return whenever the interrupt was triggered. If
+		you use poll(2), set the events POLLPRI and POLLERR. If you
+		use select(2), set the file descriptor in exceptfds. After
+		poll(2) returns, either lseek(2) to the beginning of the sysfs
+		file and read the new value or close the file and re-open it
+		to read the value.
+
 	"edge" ... reads as either "none", "rising", "falling", or
 		"both". Write these strings to select the signal edge(s)
 		that will make poll(2) on the "value" file return.
-- 
1.7.1

