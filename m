Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1BVW1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:27:45 -0500
Received: from kroah.org ([198.145.64.141]:32924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab1BVWWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.909940069@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [49/70] hwmon: (jc42) fix type mismatch
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit e866729605a43a739fc56023a8530b07a93d3458 upstream.

In set_temp_crit_hyst(), make the variable 'val' have the correct
type for strict_strtoul().

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/hwmon/jc42.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -332,7 +332,7 @@ static ssize_t set_temp_crit_hyst(struct
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct jc42_data *data = i2c_get_clientdata(client);
-	long val;
+	unsigned long val;
 	int diff, hyst;
 	int err;
 	int ret = count;


