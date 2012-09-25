Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2IYU2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:28:03 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42828 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2IYU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:28:01 -0400
Date: Tue, 25 Sep 2012 23:27:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: durgadoss.r@intel.com
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org
Subject: re: Thermal: Update binding logic based on platform data
Message-ID: <20120925202747.GA19537@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Durgadoss R,

This is a semi-automatic email about new static checker warnings.

The patch 9b70dfa68ae8: "Thermal: Update binding logic based on 
platform data" from Sep 18, 2012, leads to the following Smatch 
complaint:

drivers/thermal/thermal_sys.c:292 bind_tz()
	 error: we previously assumed 'tzp' could be null (see line 283)

drivers/thermal/thermal_sys.c
   282		/* If there is no platform data, try to use ops->bind */
   283		if (!tzp && tz->ops->bind) {
                    ^^^^
New check.

   284			list_for_each_entry(pos, &thermal_cdev_list, node) {
   285				ret = tz->ops->bind(tz, pos);
   286				if (ret)
   287					print_bind_err_msg(tz, pos, ret);
   288			}
   289			goto exit;
   290		}
   291	
   292		if (!tzp->tbp)
                     ^^^^^^^^
New dereference.

   293			goto exit;
   294	

There are also some locking bugs which need to be fixed as well.

drivers/thermal/thermal_sys.c:268 bind_cdev() warn: inconsistent returns mutex:&thermal_list_lock: locked (256) unlocked (268)
drivers/thermal/thermal_sys.c:396 update_temperature() warn: inconsistent returns mutex:&tz->lock: locked (390) unlocked (396)

regards,
dan carpenter


