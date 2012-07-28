Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2G1Meu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 08:34:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:10274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab2G1Met (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 08:34:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="188518583"
Date: Sat, 28 Jul 2012 20:34:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: drivers/mfd/tps65090.c: duplicated TPS65090_INT_STS tests
Message-ID: <20120728123441.GB11202@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

Is this coccinelle warning a trivial one, or indicates some copy&paste
error? It's introduced by commit 3c33be06 ("mfd: Add support for
TPS65090").

drivers/mfd/tps65090.c:239:5-30: duplicated argument to && or ||

vim +239 drivers/mfd/tps65090.c
   236	
   237	static bool is_volatile_reg(struct device *dev, unsigned int reg)
   238	{
 > 239		if ((reg == TPS65090_INT_STS) || (reg == TPS65090_INT_STS))
   240			return true;
   241		else
   242			return false;

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
