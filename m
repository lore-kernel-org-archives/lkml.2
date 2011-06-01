Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162670Ab1FAI2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:28:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162224Ab1FAI1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:27:55 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:18 2011
Message-Id: <20110601081217.404636424@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:54 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [144/165] atm: expose ATM device index in sysfs
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1808
Lines: 53

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

---
 net/atm/atm_sysfs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
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


