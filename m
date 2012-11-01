Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2KAGsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:48:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63813 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2KAGsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:48:52 -0400
Message-ID: <1351752521.4588.2.camel@phoenix>
Subject: regulator: tps51632: Seems current code doesn't properly support
 dvfs_step_20mV case
From: Axel Lin <axel.lin@ingics.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Thu, 01 Nov 2012 14:48:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

While reading the tps51632 driver, I found there is a dvfs_step_20mV setting
in platform data. But seems current code doesn't properly handle the case when
dvfs_step_20mV is true.

I guess if pdata->dvfs_step_20mV is true, we need:

tps->desc.uV_step = TPS51632_VOLATGE_STEP_20mV;
Fix TPS51632_VOLT_VSEL macro to support dvfs_step_20mV case.
Also I'm wondering if either TPS51632_MAX_VSEL/TPS51632_MAX_VOLATGE or
desc.n_voltages needs change for dvfs_step_20mV case.

Oh, I don't have the datasheet, so my understanding might be wrong.

Regards,
Axel


