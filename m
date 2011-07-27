Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1G0Vsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:26130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab1G0Vs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043575"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: dcbw@redhat.com, eric.dumazet@gmail.com, dwmw2@infradead.org,
        davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [28/99] atm: expose ATM device index in sysfs
Message-Id: <20110727214826.CBF482403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Williams <dcbw@redhat.com>

commit e7a46b4d0839c2a3aa2e0ae0b145f293f6738498 upstream.

It's currently exposed only through /proc which, besides requiring
screen-scraping, doesn't allow userspace to distinguish between two
identical ATM adapters with different ATM indexes.  The ATM device index
is required when using PPPoATM on a system with multiple ATM adapters.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/atm/atm_sysfs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.35.y/net/atm/atm_sysfs.c
===================================================================
--- linux-2.6.35.y.orig/net/atm/atm_sysfs.c
+++ linux-2.6.35.y/net/atm/atm_sysfs.c
@@ -59,6 +59,14 @@ static ssize_t show_atmaddress(struct de
 	return pos - buf;
 }
 
+static ssize_t show_atmindex(struct device *cdev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct atm_dev *adev = to_atm_dev(cdev);
+
+	return sprintf(buf, "%d\n", adev->number);
+}
+
 static ssize_t show_carrier(struct device *cdev,
 			    struct device_attribute *attr, char *buf)
 {
@@ -99,6 +107,7 @@ static ssize_t show_link_rate(struct dev
 
 static DEVICE_ATTR(address, S_IRUGO, show_address, NULL);
 static DEVICE_ATTR(atmaddress, S_IRUGO, show_atmaddress, NULL);
+static DEVICE_ATTR(atmindex, S_IRUGO, show_atmindex, NULL);
 static DEVICE_ATTR(carrier, S_IRUGO, show_carrier, NULL);
 static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
 static DEVICE_ATTR(link_rate, S_IRUGO, show_link_rate, NULL);
@@ -106,6 +115,7 @@ static DEVICE_ATTR(link_rate, S_IRUGO, s
 static struct device_attribute *atm_attrs[] = {
 	&dev_attr_atmaddress,
 	&dev_attr_address,
+	&dev_attr_atmindex,
 	&dev_attr_carrier,
 	&dev_attr_type,
 	&dev_attr_link_rate,
