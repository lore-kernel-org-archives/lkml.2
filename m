Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab1LGQXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab1LGQXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161219.618318525@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:01 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Axel Lin <axel.lin@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [059/104] ASoC: Fix wrong define for AD1836_ADC_WORD_OFFSET
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 72531c9434fa884d20cb3c36fcec83752f32fdf4 upstream.

According to the datasheet:
The BIT[5:4] of ADC Control Register 2 is to control the word width.
        00 = 25 Bits
        01 = 20 Bits
        10 = 16 Bits
        11 = Invalid

Thus, the AD1836_ADC_WORD_OFFSET should be defined as 4.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ad1836.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/ad1836.h
+++ b/sound/soc/codecs/ad1836.h
@@ -34,7 +34,7 @@
 
 #define AD1836_ADC_CTRL2               13
 #define AD1836_ADC_WORD_LEN_MASK       0x30
-#define AD1836_ADC_WORD_OFFSET         5
+#define AD1836_ADC_WORD_OFFSET         4
 #define AD1836_ADC_SERFMT_MASK         (7 << 6)
 #define AD1836_ADC_SERFMT_PCK256       (0x4 << 6)
 #define AD1836_ADC_SERFMT_PCK128       (0x5 << 6)


