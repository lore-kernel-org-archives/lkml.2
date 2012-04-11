Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2DKJHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:07:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31792 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2DKJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:07:00 -0400
Date: Wed, 11 Apr 2012 12:06:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org
Subject: re: regulator: core: Use a struct to pass in regulator runtime
 configuration
Message-ID: <20120411090649.GA32589@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F8549B1.00D9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark Brown,

This is a semi-automatic email about new static checker warnings.

The patch c172708d38a4: "regulator: core: Use a struct to pass in
regulator runtime configuration" from Apr 4, 2012, leads to the
following Smatch complaint:

drivers/regulator/core.c:2860 regulator_register()
	 warn: variable dereferenced before check 'config' (see line 2856)

drivers/regulator/core.c
  2855		struct regulator_dev *rdev;
  2856		struct device *dev = config->dev;
                                     ^^^^^^^^^^^
New dereference.

  2857		int ret, i;
  2858		const char *supply = NULL;
  2859	
  2860		if (regulator_desc == NULL || config == NULL)
                                              ^^^^^^^^^^^^^^
New check.

  2861			return ERR_PTR(-EINVAL);
  2862	

regards,
dan carpenter

