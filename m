Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0CTIJF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 04:09:05 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:33849 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0CTIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 04:09:00 -0400
X-SENDER-IP: [83.226.250.30]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQ8AIUfpEtT4voePGdsb2JhbACBO4QsgXeTawEBAQE3u0aEfQQ
X-IronPort-AV: E=Sophos;i="4.51,278,1267398000"; 
   d="scan'208";a="53480912"
Message-ID: <4BA4829D.3060600@coyote.org>
Date: Sat, 20 Mar 2010 09:09:01 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx.c Coding style fixes.
References: <1269018531-18891-1-git-send-email-lindley@coyote.org> <20100320001048.GA1477@ucw.cz>
In-Reply-To: <20100320001048.GA1477@ucw.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

No problem..It's fun to make a contribution.

On 2010-03-20 01:10, Pavel Machek wrote:
> Hi!
> 
> And thanks for the effort.
>
>> +	adapter->sMlmeFrame.pMMPDU = mmpdu;
> 
> I'm not sure if 'mmpdu' is good name. But I don't know what it stands
> for, either, so...
> 
I have no idea what it is either. Someone who knows what it is might have
a better name up their sleeve..

>> +	adapter->sMlmeFrame.DataType = datatype;
> 
> data_type, please...
> 
> 									Pavel
> 

Fixed..And also send_ok and packet_id..

The generated .o is identical to the one from a clean tree..

Here's a patch that applies after the old one..



[PATCH] staging: winbond: mlmetxrx.c func. argument name change.

I changed some function argument names to make them more readable.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/mlmetxrx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index 76b79f0..a8f4b8b 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -19,7 +19,7 @@
  *		FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
  *		FRAME_TYPE_802_11_DATA
  */
-u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *mmpdu, u16 len, u8 datatype)
+u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *mmpdu, u16 len, u8 data_type)
 {
 	if (adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
 		adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
@@ -29,7 +29,7 @@ u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *mmpdu, u16 len, u8 datatype)
 
 	/* Keep information for sending */
 	adapter->sMlmeFrame.pMMPDU = mmpdu;
-	adapter->sMlmeFrame.DataType = datatype;
+	adapter->sMlmeFrame.DataType = data_type;
 	/* len must be the last setting due to QUERY_SIZE_SECOND of Mds */
 	adapter->sMlmeFrame.len = len;
 	adapter->sMlmeFrame.wNumTxMMPDU++;
@@ -72,7 +72,7 @@ static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *data)
 	}
 }
 
-void MLME_SendComplete(struct wbsoft_priv *adapter, u8 packetid, unsigned char sendok)
+void MLME_SendComplete(struct wbsoft_priv *adapter, u8 packet_id, unsigned char send_ok)
 {
 	MLME_TXCALLBACK	TxCallback;
 
-- 
1.7.0.2
