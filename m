Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab0C2MAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:00:49 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:35788 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0C2MAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z59cq3kpg3cnitV0o7liib5NRLxLLhYN+gYi05dcogpfWzvJQDbcO1+bvxBPcGzrIC
         c7Dy2sYiZFo5qf5kAgg1M+1MF4lxFhTF72iNq5cf+I5Wje7v5Ud+nc+4GCzitolEGbRG
         W0senpQQBcWumRqJ9DNu1DTFhWQe2cUO8w1x0=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 6/6] staging: vt6656: michael.c: Fixed coding style issues
Date: Mon, 29 Mar 2010 23:20:36 +1100
Message-Id: <1269865236-16782-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced lots of spaces by real tabs and resolved other minor issues.
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/vt6656/michael.c |  177 ++++++++++++++++++-------------------
 1 files changed, 86 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/vt6656/michael.c b/drivers/staging/vt6656/michael.c
index c930e0c..d4c0820 100644
--- a/drivers/staging/vt6656/michael.c
+++ b/drivers/staging/vt6656/michael.c
@@ -48,20 +48,23 @@
 
 /*---------------------  Static Functions  --------------------------*/
 /*
-static DWORD s_dwGetUINT32(BYTE * p);         // Get DWORD from 4 bytes LSByte first
-static VOID s_vPutUINT32(BYTE* p, DWORD val); // Put DWORD into 4 bytes LSByte first
-*/
-static VOID s_vClear(void);                       // Clear the internal message,
-                                              // resets the object to the state just after construction.
+ * static DWORD s_dwGetUINT32(BYTE * p);         Get DWORD from
+ *							4 bytes LSByte first
+ * static VOID s_vPutUINT32(BYTE* p, DWORD val); Put DWORD into
+ *							4 bytes LSByte first
+ */
+static VOID s_vClear(void);		/* Clear the internal message,
+					 * resets the object to the
+					 * state just after construction. */
 static VOID s_vSetKey(DWORD dwK0, DWORD dwK1);
-static VOID s_vAppendByte(BYTE b);            // Add a single byte to the internal message
+static VOID s_vAppendByte(BYTE b);	/* Add a single byte to the internal
+					 * message */
 
 /*---------------------  Export Variables  --------------------------*/
-static DWORD  L, R;           // Current state
-
-static DWORD  K0, K1;         // Key
-static DWORD  M;              // Message accumulator (single word)
-static UINT   nBytesInM;      // # bytes in M
+static DWORD  L, R;		/* Current state */
+static DWORD  K0, K1;		/* Key */
+static DWORD  M;		/* Message accumulator (single word) */
+static UINT   nBytesInM;	/* # bytes in M */
 
 /*---------------------  Export Functions  --------------------------*/
 
@@ -69,113 +72,105 @@ static UINT   nBytesInM;      // # bytes in M
 static DWORD s_dwGetUINT32 (BYTE * p)
 // Convert from BYTE[] to DWORD in a portable way
 {
-    DWORD res = 0;
-    UINT i;
-    for(i=0; i<4; i++ )
-    {
-        res |= (*p++) << (8*i);
-    }
-    return res;
+	DWORD res = 0;
+	UINT i;
+	for(i=0; i<4; i++ )
+		res |= (*p++) << (8*i);
+	return res;
 }
 
 static VOID s_vPutUINT32 (BYTE* p, DWORD val)
 // Convert from DWORD to BYTE[] in a portable way
 {
-    UINT i;
-    for(i=0; i<4; i++ )
-    {
-        *p++ = (BYTE) (val & 0xff);
-        val >>= 8;
-    }
+	UINT i;
+	for(i=0; i<4; i++ ) {
+		*p++ = (BYTE) (val & 0xff);
+		val >>= 8;
+	}
 }
 */
 
-static VOID s_vClear (void)
+static VOID s_vClear(void)
 {
-    // Reset the state to the empty message.
-    L = K0;
-    R = K1;
-    nBytesInM = 0;
-    M = 0;
+	/* Reset the state to the empty message. */
+	L = K0;
+	R = K1;
+	nBytesInM = 0;
+	M = 0;
 }
 
-static VOID s_vSetKey (DWORD dwK0, DWORD dwK1)
+static VOID s_vSetKey(DWORD dwK0, DWORD dwK1)
 {
-    // Set the key
-    K0 = dwK0;
-    K1 = dwK1;
-    // and reset the message
-    s_vClear();
+	/* Set the key */
+	K0 = dwK0;
+	K1 = dwK1;
+	/* and reset the message */
+	s_vClear();
 }
 
-static VOID s_vAppendByte (BYTE b)
+static VOID s_vAppendByte(BYTE b)
 {
-    // Append the byte to our word-sized buffer
-    M |= b << (8*nBytesInM);
-    nBytesInM++;
-    // Process the word if it is full.
-    if( nBytesInM >= 4 )
-    {
-        L ^= M;
-        R ^= ROL32( L, 17 );
-        L += R;
-        R ^= ((L & 0xff00ff00) >> 8) | ((L & 0x00ff00ff) << 8);
-        L += R;
-        R ^= ROL32( L, 3 );
-        L += R;
-        R ^= ROR32( L, 2 );
-        L += R;
-        // Clear the buffer
-        M = 0;
-        nBytesInM = 0;
-    }
+	/* Append the byte to our word-sized buffer */
+	M |= b << (8*nBytesInM);
+	nBytesInM++;
+	/* Process the word if it is full. */
+	if (nBytesInM >= 4) {
+		L ^= M;
+		R ^= ROL32(L, 17);
+		L += R;
+		R ^= ((L & 0xff00ff00) >> 8) | ((L & 0x00ff00ff) << 8);
+		L += R;
+		R ^= ROL32(L, 3);
+		L += R;
+		R ^= ROR32(L, 2);
+		L += R;
+		/* Clear the buffer */
+		M = 0;
+		nBytesInM = 0;
+	}
 }
 
-VOID MIC_vInit (DWORD dwK0, DWORD dwK1)
+VOID MIC_vInit(DWORD dwK0, DWORD dwK1)
 {
-    // Set the key
-    s_vSetKey(dwK0, dwK1);
+	/* Set the key */
+	s_vSetKey(dwK0, dwK1);
 }
 
 
-VOID MIC_vUnInit (void)
+VOID MIC_vUnInit(void)
 {
-    // Wipe the key material
-    K0 = 0;
-    K1 = 0;
+	/* Wipe the key material */
+	K0 = 0;
+	K1 = 0;
 
-    // And the other fields as well.
-    //Note that this sets (L,R) to (K0,K1) which is just fine.
-    s_vClear();
+	/* And the other fields as well. */
+	/* Note that this sets (L,R) to (K0,K1) which is just fine. */
+	s_vClear();
 }
 
-VOID MIC_vAppend (PBYTE src, UINT nBytes)
+VOID MIC_vAppend(PBYTE src, UINT nBytes)
 {
-    // This is simple
-    while (nBytes > 0)
-    {
-        s_vAppendByte(*src++);
-        nBytes--;
-    }
+    /* This is simple */
+	while (nBytes > 0) {
+		s_vAppendByte(*src++);
+		nBytes--;
+	}
 }
 
-VOID MIC_vGetMIC (PDWORD pdwL, PDWORD pdwR)
+VOID MIC_vGetMIC(PDWORD pdwL, PDWORD pdwR)
 {
-    // Append the minimum padding
-    s_vAppendByte(0x5a);
-    s_vAppendByte(0);
-    s_vAppendByte(0);
-    s_vAppendByte(0);
-    s_vAppendByte(0);
-    // and then zeroes until the length is a multiple of 4
-    while( nBytesInM != 0 )
-    {
-        s_vAppendByte(0);
-    }
-    // The s_vAppendByte function has already computed the result.
-    *pdwL = L;
-    *pdwR = R;
-    // Reset to the empty message.
-    s_vClear();
+	/* Append the minimum padding */
+	s_vAppendByte(0x5a);
+	s_vAppendByte(0);
+	s_vAppendByte(0);
+	s_vAppendByte(0);
+	s_vAppendByte(0);
+	/* and then zeroes until the length is a multiple of 4 */
+	while (nBytesInM != 0)
+		s_vAppendByte(0);
+	/* The s_vAppendByte function has already computed the result. */
+	*pdwL = L;
+	*pdwR = R;
+	/* Reset to the empty message. */
+	s_vClear();
 }
-
-- 
1.6.3.3

