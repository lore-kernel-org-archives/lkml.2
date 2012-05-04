Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2EDVLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:11:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2EDUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:06 -0400
Message-Id: <20120504204227.974112268@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gabor Juhos <juhosg@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [ 42/75] MIPS: ath79: fix AR933X WMAC reset code
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit de14ca6ae2c592d66db88f1e5596b26f7f011384 upstream.

The current code puts the built-in WMAC device of the
AR933X SoCs into reset instead of starting it. This
causes a hard lock on AR933X based boards when the
wireless driver tries to access the device.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/3484/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/ath79/dev-wmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/ath79/dev-wmac.c
+++ b/arch/mips/ath79/dev-wmac.c
@@ -58,8 +58,8 @@ static void __init ar913x_wmac_setup(voi
 
 static int ar933x_wmac_reset(void)
 {
-	ath79_device_reset_clear(AR933X_RESET_WMAC);
 	ath79_device_reset_set(AR933X_RESET_WMAC);
+	ath79_device_reset_clear(AR933X_RESET_WMAC);
 
 	return 0;
 }


