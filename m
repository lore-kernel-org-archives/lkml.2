Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0FYSF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:05:29 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:3797 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932222Ab0FYSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:05:28 -0400
Date: Fri, 25 Jun 2010 22:05:27 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@simtec.co.uk>,
       Richard =?utf-8?Q?R=C3=B6jfors?= <richard.rojfors@pelagicore.com>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add support for CNS3xxx SDHCI hosts
Message-ID: <20100625180527.GA11280@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Ben Dooks once suggested that we'd better keep SDHCI SoC-specific
stuff in the driver/mmc/, as it's done for SDHCI S3C, eSDHC and
HLWD devices. This helps maintain the code, and keeps MMC-specific
stuff out of the platform code.

We already do this for OpenFirmware platforms (see sdhci-of-*),
but the infrastructure isn't ready for the platform devices.

This patch set adds CNS3xxx SoC support. But to not duplicate the
sdhci-pltfm code, it converts the driver to module device table
matching, and then just adds CNS3xxx-specific driver_data.

Further more, as OF and Platform buses are going to be merged
soon, this patch set also helps the transition.

Plus, if anybody is willing, sdhci-s3c can be merged into
sdhci-pltfm (need to implement struct clk handling for this).

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
