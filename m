Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab0HLAIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:08:19 -0400
Received: from kroah.org ([198.145.64.141]:47796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095Ab0HLAIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:16 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:14 2010
Message-Id: <20100812000614.784450541@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [23/67] iwlwifi: fix TX tracer
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit e95b743536937a72e1560c85696b425c5d1a1c18 upstream.

The TX tracing code copies with the wrong length,
which will typically copy too little data. Fix
this by using the correct length variable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -193,7 +193,7 @@ TRACE_EVENT(iwlwifi_dev_tx,
 		__entry->framelen = buf0_len + buf1_len;
 		memcpy(__get_dynamic_array(tfd), tfd, tfdlen);
 		memcpy(__get_dynamic_array(buf0), buf0, buf0_len);
-		memcpy(__get_dynamic_array(buf1), buf1, buf0_len);
+		memcpy(__get_dynamic_array(buf1), buf1, buf1_len);
 	),
 	TP_printk("[%p] TX %.2x (%zu bytes)",
 		  __entry->priv,


