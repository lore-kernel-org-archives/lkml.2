Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2GASQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46895 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab2GASQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:21 -0400
Message-Id: <20120701172006.851343861@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 01/48] staging:iio:ad7606: Re-add missing scale attribute
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 279bf2e57c30c9a4482b2b6ede11b31c41e35e78 upstream.

Commit 50ac23be ("staging:iio:adc:ad7606 add local define for chan_spec
structures.") accidentally removed the scale info_mask flag. This patch
adds it back again.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - info_mask was completely gone rather than set to another flag
 - IIO_CHAN_INFO_SCALE_SHARED_BIT was not defined; write it out as a shift]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/staging/iio/adc/ad7606_core.c
+++ b/drivers/staging/iio/adc/ad7606_core.c
@@ -241,6 +241,7 @@
 		.indexed = 1,				\
 		.channel = num,				\
 		.address = num,				\
+		.info_mask = (1 << IIO_CHAN_INFO_SCALE_SHARED), \
 		.scan_index = num,			\
 		.scan_type = IIO_ST('s', 16, 16, 0),	\
 	}


