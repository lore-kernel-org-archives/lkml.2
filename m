Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0C2S6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:58:04 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:43186 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0C2S6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:58:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nb02OY1LolWwQDbON6bVGM0Y088vtvN76aNfUZI6A2c6TA3ZIRt2kjyUrMRJH+2TVY
         LEpsDB5x+G4867O0LAmyw9jW03nrOahjSow3w2ZHu6uJCMnOhECIJj+YtHuihhJuWNop
         O5CFjnY9QabiD2HbFdGSdS+Me4DetnwM9wPzc=
Message-ID: <4BB0F82E.8000601@googlemail.com>
Date: Mon, 29 Mar 2010 20:57:50 +0200
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.2pre) Gecko/20100302 Lanikai/3.1b1
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] No SPROM available!
References: <4BB0CE4C.40306@googlemail.com>
In-Reply-To: <4BB0CE4C.40306@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/10 17:59, René Bolldorf wrote:
> Hi John,
>
> since commit fcb54b0bf7d3fe730c2b72e224bc616e358f24cb, my b43 (4312)
> device doesn't work.
>
> But the device have a sprom. Maybe the chip-status register check is wrong?
>
> +/** Macros to determine SPROM presence based on Chip-Status register. */
> +#define SSB_CHIPCO_CHST_4312_SPROM_PRESENT(status) \
> + ((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
> + SSB_CHIPCO_CHST_4325_OTP_SEL)

I have talked with my colleague and he have the same problem. I have 
made a patch , for me it works and should work for others too. My 
colleague testing this in the late evening.

diff --git a/include/linux/ssb/ssb_driver_chipcommon.h 
b/include/linux/ssb/ssb_driver_chipcommon.h
index 2cdf249..1e0b9cd 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -386,6 +386,7 @@


  /** Chip specific Chip-Status register contents. */
+#define SSB_CHIPCO_CHST_4312_SPROM_EXISTS	0x00000025
  #define SSB_CHIPCO_CHST_4322_SPROM_EXISTS	0x00000040 /* SPROM present */
  #define SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL	0x00000003
  #define SSB_CHIPCO_CHST_4325_DEFCIS_SEL		0 /* OTP is powered up, use 
def. CIS, no SPROM */
@@ -403,7 +404,7 @@
  /** Macros to determine SPROM presence based on Chip-Status register. */
  #define SSB_CHIPCO_CHST_4312_SPROM_PRESENT(status) \
  	((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
-		SSB_CHIPCO_CHST_4325_OTP_SEL)
+		SSB_CHIPCO_CHST_4312_SPROM_EXISTS)
  #define SSB_CHIPCO_CHST_4322_SPROM_PRESENT(status) \
  	(status & SSB_CHIPCO_CHST_4322_SPROM_EXISTS)
  #define SSB_CHIPCO_CHST_4325_SPROM_PRESENT(status) \
