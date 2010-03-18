Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0CRWRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:17:53 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:50912 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0CRWRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:17:52 -0400
X-SENDER-IP: [83.226.250.86]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aiw9AHhDoktT4vpWPGdsb2JhbACBPYQsgXeTWQEBAQE3vSCEeQQ
X-IronPort-AV: E=Sophos;i="4.51,269,1267398000"; 
   d="scan'208";a="52960044"
Message-ID: <4BA2A68D.9050401@coyote.org>
Date: Thu, 18 Mar 2010 23:17:49 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
References: <1268927857-14141-1-git-send-email-lindley@coyote.org> <4BA254BC.6090507@cs.helsinki.fi>
In-Reply-To: <4BA254BC.6090507@cs.helsinki.fi>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-18 17:28, Pekka Enberg wrote:
> Lars Lindley wrote:
>> I fixed all problems found by checkpatch.pl and removed CamelCase
>> from argument names.
..snip..
>> +void MLME_GetNextPacket(struct wbsoft_priv *adapter,
>> +            struct wb35_descriptor *pdes);
> 
> Can we get rid of the "p" prefix (hungarian notation) while at it?
> 
Sure..
I changed pdes to des, pmmpdu to mmpdu and widx to idx.
Looks all right?

/Lars



Here is the new patch against master:

[PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.

I fixed all problems found by checkpatch.pl and removed CamelCase
and hungarian notation from the argument names.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/mlmetxrx_f.h |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index 6c04e3e..2bfa2e3 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -1,25 +1,26 @@
-//================================================================
-// MLMETxRx.H --
-//
-//   Functions defined in MLMETxRx.c.
-//
-// Copyright (c) 2002 Winbond Electrics Corp. All Rights Reserved.
-//================================================================
+/* ================================================================
+ * MLMETxRx.H --
+ *
+ *   Functions defined in MLMETxRx.c.
+ *
+ * Copyright (c) 2002 Winbond Electrics Corp. All Rights Reserved.
+ * ================================================================
+ */
 #ifndef _MLMETXRX_H
 #define _MLMETXRX_H

 #include "core.h"

-void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
+void MLME_GetNextPacket(struct wbsoft_priv *adapter,
+                       struct wb35_descriptor *des);
 u8 MLMESendFrame(struct wbsoft_priv *adapter,
-                u8 * pMMPDU, u16 len, u8 DataType);
+                u8 *mmpdu, u16 len, u8 datatype);

-void
-MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
-                 unsigned char SendOK);
+void MLME_SendComplete(struct wbsoft_priv *adapter, u8 packetid,
+                       unsigned char sendok);

 #ifdef _IBSS_BEACON_SEQ_STICK_
-s8 SendBCNullData(struct wbsoft_priv *adapter, u16 wIdx);
+s8 SendBCNullData(struct wbsoft_priv *adapter, u16 idx);
 #endif

 #endif
-- 
1.7.0.2
