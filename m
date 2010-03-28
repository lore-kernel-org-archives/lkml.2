Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab0C1HqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 03:46:23 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:41837 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0C1HqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 03:46:22 -0400
X-SENDER-IP: [83.226.249.196]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYzAJ6lrktT4vnEPGdsb2JhbACBPoQ8gW2TTAEBAQE1vFGFAQQ
X-IronPort-AV: E=Sophos;i="4.51,321,1267398000"; 
   d="scan'208";a="56561160"
Message-ID: <4BAEFB3C.1090809@coyote.org>
Date: Sun, 28 Mar 2010 08:46:20 +0200
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100322 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35tx_s.h Coding style fixes.
References: <1269615817-3565-1-git-send-email-lindley@coyote.org> <20100327060649.GB18689@elf.ucw.cz>
In-Reply-To: <20100327060649.GB18689@elf.ucw.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-27 07:06, Pavel Machek wrote:
> On Fri 2010-03-26 16:03:37, Lars Lindley wrote:
>> I fixed all reported checkpatch issues.
>> I also removed versioning comments.
>> I checked for oopses with Dan Carpenters strip_whitespace.pl
>> and diff.
>>
>> Signed-off-by: <lindley@coyote.org>
> 
> Please add your name here. 
> 
> ACK.
> 

Oops.. :)



[PATCH] staging: winbond: wb35tx_s.h Coding style fixes.

I fixed all reported checkpatch issues.
I also removed versioning comments.
I checked for oopses with Dan Carpenters strip_whitespace.pl
and diff.

Signed-off-by: Lars Lindley <lindley@coyote.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/staging/winbond/wb35tx_s.h |   62 ++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
index f70f433..6799048 100644
--- a/drivers/staging/winbond/wb35tx_s.h
+++ b/drivers/staging/winbond/wb35tx_s.h
@@ -3,45 +3,47 @@
 
 #include "mds_s.h"
 
-//====================================
-// IS89C35 Tx related definition
-//====================================
-#define TX_INTERFACE			0	// Interface 1
-#define TX_PIPE					3	// endpoint 4
-#define TX_INTERRUPT			1	// endpoint 2
-#define MAX_INTERRUPT_LENGTH	64	// It must be 64 for EP2 hardware
-
-
-
-//====================================
-// Internal variable for module
-//====================================
-
-
+/*
+ * ====================================
+ * IS89C35 Tx related definition
+ * ====================================
+ */
+#define TX_INTERFACE		0	/* Interface 1 */
+#define TX_PIPE			3	/* endpoint 4 */
+#define TX_INTERRUPT		1	/* endpoint 2 */
+#define MAX_INTERRUPT_LENGTH	64	/* It must be 64 for EP2 hardware */
+
+
+
+/*
+ * ====================================
+ * Internal variable for module
+ * ====================================
+ */
 struct wb35_tx {
-	// For Tx buffer
-	u8	TxBuffer[ MAX_USB_TX_BUFFER_NUMBER ][ MAX_USB_TX_BUFFER ];
+	/* For Tx buffer */
+	u8		TxBuffer[MAX_USB_TX_BUFFER_NUMBER][MAX_USB_TX_BUFFER];
 
-	// For Interrupt pipe
-	u8	EP2_buf[MAX_INTERRUPT_LENGTH];
+	/* For Interrupt pipe */
+	u8		EP2_buf[MAX_INTERRUPT_LENGTH];
 
-	atomic_t	TxResultCount;// For thread control of EP2 931130.4.m
-	atomic_t	TxFireCounter;// For thread control of EP4 931130.4.n
-	u32			ByteTransfer;
+	atomic_t	TxResultCount; /* For thread control of EP2 */
+	atomic_t	TxFireCounter; /* For thread control of EP4 */
+	u32		ByteTransfer;
 
-	u32	    TxSendIndex;// The next index of Mds array to be sent
-	u32	    EP2vm_state; // for EP2vm state
-	u32	    EP4vm_state; // for EP4vm state
-	u32	    tx_halt; // Stopping VM
+	u32		TxSendIndex;/* The next index of Mds array to be sent */
+	u32		EP2vm_state; /* for EP2vm state */
+	u32		EP4vm_state; /* for EP4vm state */
+	u32		tx_halt; /* Stopping VM */
 
-	struct urb *				Tx4Urb;
-	struct urb *				Tx2Urb;
+	struct urb	*Tx4Urb;
+	struct urb	*Tx2Urb;
 
 	int		EP2VM_status;
 	int		EP4VM_status;
 
-	u32	TxFillCount; // 20060928
-	u32	TxTimer; // 20060928 Add if sending packet not great than 13
+	u32		TxFillCount;
+	u32		TxTimer; /* Add if sending packet not great than 13 */
 };
 
 #endif
-- 
1.7.0.3
