Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965882Ab2B2SLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:11:06 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44072 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965366Ab2B2SLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:11:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6634"; a="165301970"
Message-ID: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
Date: Wed, 29 Feb 2012 10:10:59 -0800 (PST)
Subject: Re: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5   
        device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, "'Maya Erez'" <merez@codeaurora.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch supports packed command of eMMC4.5 device.
> Several reads(or writes) can be grouped in packed command
> and all data of the individual commands can be sent in a
> single transfer on the bus.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/mmc/card/block.c   |  496
> +++++++++++++++++++++++++++++++++++++++++--
>  drivers/mmc/card/queue.c   |   48 ++++-
>  drivers/mmc/card/queue.h   |   13 ++
>  drivers/mmc/core/mmc_ops.c |    1 +
>  include/linux/mmc/core.h   |    4 +
>  5 files changed, 535 insertions(+), 27 deletions(-)
>
Hi,

We ran performance tests on the packed commands patch. We found out that
enabling the read packing didn't improve the performance in any of the
scenarios we ran (see the detailed results below).
Therefore, we suggest to move the read packing code to a different patch
and approve only the write packing code for now. The read packing adds
complexity to the code and we don't see a point in adding it while the
intention is to disable it.

Test results:

Long read operation:
----------------------
no-packing: 39.5 MB/s
packed commands patch (both READ and WRITE packing are enabled): 39.5 MB/s
packed commands patch + enabling only READ packing: 39.5 MB/s

Several parallel read operations (sum of all the read throughputs):
---------------------------
no-packing: 42.6 MB/s
packed commands patch(both READ and WRITE packing are enabled): 38 MB/s
packed commands patch + enabling only READ packing: 38.2 MB/s

Parallel long read and long write operations (read throughput):
-----------------------------------------------------------------
no-packing: 23.8 MB/s
packed commands patch (both READ and WRITE packing are enabled): 12.6 MB/s
packed commands patch + enabling only READ packing: 12.5 MB/s

Parallel short read and long write operations (read throughput):
-----------------------------------------------------------------
no-packing: 22.9 MB/s
packed commands patch (both READ and WRITE packing are enabled): 8.4 MB/s
packed commands patch + enabling only READ packing: 8.6 MB/s

Several Parallel short read and short write operations (sum of all the
read throughputs):
--------------------------------------------------------------------------
no-packing: 41.6 MB/s
packed commands patch (both READ and WRITE packing are enabled): 35 MB/s
packed commands patch + enabling only READ packing: 36 MB/s

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





