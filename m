Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab0J1ElY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 00:41:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34006 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0J1ElW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 00:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=KcZlaSM4y78L8vm1srJgz4Fgf2T/i5ebZqStalKgeSFSa/0zpGXS9tUiTvIE0L+iDk
         QF+BLYWm1uelHzFtfIee957OkNBHTbe0ID8RC8eOLVDit3IqN+2OeqU9y53gk119RWdK
         hBXkcU6MDX4DTuv8fHioYrUfdiVlL5y1okvus=
Date: Thu, 28 Oct 2010 06:41:11 +0200
From: Dan Carpenter <error27@gmail.com>
To: Hong Liu <hong.liu@intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Anantha Narayanan <anantha.narayanan@intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] misc/apds9802als: signedness bug in
	als_sensing_range_store()
Message-ID: <20101028044111.GT6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Hong Liu <hong.liu@intel.com>, Alan Cox <alan@linux.intel.com>,
	Anantha Narayanan <anantha.narayanan@intel.com>,
	Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling breaks if "ret_val" is unsigned here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index f9b91ba..0ed0935 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -123,7 +123,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct als_data *data = i2c_get_clientdata(client);
-	unsigned int ret_val;
+	int ret_val;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 10, &val))
