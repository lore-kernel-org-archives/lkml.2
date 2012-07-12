Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162385Ab2GLWqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162362Ab2GLWp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        "Herton R. Krzesinski" <herton@canonical.com>
Subject: [ 179/187] staging:iio:ad7606: Re-add missing scale attribute
Date: Thu, 12 Jul 2012 15:35:35 -0700
Message-Id: <20120712191539.881122678@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 279bf2e57c30c9a4482b2b6ede11b31c41e35e78 upstream.

Commit 50ac23be ("staging:iio:adc:ad7606 add local define for chan_spec
structures.") accidentally removed the scale info_mask flag. This patch
adds it back again.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[herton: Backported to 3.4: info_mask was not used yet with another flag]
Signed-off-by: Herton R. Krzesinski <herton@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/adc/ad7606_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/iio/adc/ad7606_core.c
+++ b/drivers/staging/iio/adc/ad7606_core.c
@@ -235,6 +235,7 @@ static const struct attribute_group ad76
 		.indexed = 1,				\
 		.channel = num,				\
 		.address = num,				\
+		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT, \
 		.scan_index = num,			\
 		.scan_type = IIO_ST('s', 16, 16, 0),	\
 	}


