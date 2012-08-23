Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2HWF5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:57:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33445 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2HWF5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:57:02 -0400
Date: Wed, 22 Aug 2012 22:57:00 -0700 (PDT)
Message-Id: <20120822.225700.714020017287504609.davem@davemloft.net>
To: cjren@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com,
        xiong@qca.qualcomm.com, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v2] net: add new QCA alx ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
References: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <cjren@qca.qualcomm.com>
Date: Tue, 21 Aug 2012 00:42:29 +0800

> +config ALX_DEBUGFS
> +	bool "Qualcomm Atheros debugging interface"
> +	depends on ALX && DEBUG_FS
> +	---help---
> +	  This option adds ability to debug and test L1F. It can
> +	  support Qualcomm Atheros tools, including diagnostic, memcfg
> +	  and SWOI.

Sorry, no vendor specific interfaces, you have to remove this.

Anything diagnostic you think is special and unique to your piece of
hardware, is almost certainly not, and therefore needs to exist as a
generic ethtool or similar interface that other drivers can plug into,
not just your's.

Driver specific interfaces suck for several reasons, not least of
which is the fact that it leads to a terrible user experience.  The
same task must be done in different ways depending upon what piece of
networking hardware and device driver are being used, which the user
should never need to know.

This is why we require that portable, sane, interfaces are added
to ethtool for driver diagnostics.  That way users can perform
a task in the same way regardless of what hardware and driver
are underneath.
