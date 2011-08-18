Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1HRRCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:02:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64470 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1HRRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:02:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6441"; a="111089431"
Date: Thu, 18 Aug 2011 10:02:26 -0700
From: David Brown <davidb@codeaurora.org>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: of_iomap() matched with plan iounmap()
Message-ID: <20110818170226.GA16721@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SPARC target contains of_ioremap() and of_iounmap(), which various
drivers use (generally inside of CONFIG_SBUS).

include/linux/of_address.h contains a definition for of_iomap(), but
not corresponding unmap call.  Code using this calls the regular
iounmap().

Is it safe to assume that of_iomap() will always be based on ioremap()
and therefore it is safe to use iounmap(), or would it be better to
define another name for drivers to use as the inverse of of_iomap().
I'm not sure what to call it, since of_iounmap() is already taken by
SPARC.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
