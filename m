Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2BRUvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 15:51:41 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25747 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2BRUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 15:51:40 -0500
Date: Sat, 18 Feb 2012 23:51:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: neilb@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: re: w1: Fix w1_bq27000
Message-ID: <20120218205125.GA26827@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F400F55.0041,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello NeilBrown,

This is a semi-automatic email about new static checker warnings.

The patch 9f3519d2ed26: "w1: Fix w1_bq27000" from Feb 15, 2012, leads 
to the following Smatch complaint:

drivers/w1/slaves/w1_bq27000.c:48 w1_bq27000_read()
	 warn: variable dereferenced before check 'dev' (see line 46)

drivers/w1/slaves/w1_bq27000.c
    45		u8 val;
    46		struct w1_slave *sl = container_of(dev->parent, struct w1_slave, dev);
                                                   ^^^^^^^^^^^
New dereference.

    47	
    48		if (!dev)
                     ^^^
Old check.

    49			return 0;
    50	

regards,
dan carpenter

