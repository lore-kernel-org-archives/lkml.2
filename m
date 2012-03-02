Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2CBAJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:09:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46954 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2CBAJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:09:13 -0500
X-AuditID: cbfee61b-b7c62ae000000989-54-4f500fa0805e
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
In-reply-to: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Fri, 02 Mar 2012 09:09:05 +0900
Message-id: <004301ccf808$ae796580$0b6c3080$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz3DYODijrIASKBRRKecyv7yegn5gA971Ug
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maya Erez <merez@codeaurora.org> wrote:
> > This patch supports packed command of eMMC4.5 device.
> > Several reads(or writes) can be grouped in packed command
> > and all data of the individual commands can be sent in a
> > single transfer on the bus.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >  drivers/mmc/card/block.c   |  496
> > +++++++++++++++++++++++++++++++++++++++++--
> >  drivers/mmc/card/queue.c   |   48 ++++-
> >  drivers/mmc/card/queue.h   |   13 ++
> >  drivers/mmc/core/mmc_ops.c |    1 +
> >  include/linux/mmc/core.h   |    4 +
> >  5 files changed, 535 insertions(+), 27 deletions(-)
> >
> Hi,
> 
> We ran performance tests on the packed commands patch. We found out that
> enabling the read packing didn't improve the performance in any of the
> scenarios we ran (see the detailed results below).
> Therefore, we suggest to move the read packing code to a different patch
> and approve only the write packing code for now. The read packing adds
> complexity to the code and we don't see a point in adding it while the
> intention is to disable it.
> 
Thank you for test.
What is your test tool?
Is there any improvement point we can discuss for packed read?

Thanks,
Seungwon Jeon.

> Test results:
> 
> Long read operation:
> ----------------------
> no-packing: 39.5 MB/s
> packed commands patch (both READ and WRITE packing are enabled): 39.5 MB/s
> packed commands patch + enabling only READ packing: 39.5 MB/s
> 
> Several parallel read operations (sum of all the read throughputs):
> ---------------------------
> no-packing: 42.6 MB/s
> packed commands patch(both READ and WRITE packing are enabled): 38 MB/s
> packed commands patch + enabling only READ packing: 38.2 MB/s
> 
> Parallel long read and long write operations (read throughput):
> -----------------------------------------------------------------
> no-packing: 23.8 MB/s
> packed commands patch (both READ and WRITE packing are enabled): 12.6 MB/s
> packed commands patch + enabling only READ packing: 12.5 MB/s
> 
> Parallel short read and long write operations (read throughput):
> -----------------------------------------------------------------
> no-packing: 22.9 MB/s
> packed commands patch (both READ and WRITE packing are enabled): 8.4 MB/s
> packed commands patch + enabling only READ packing: 8.6 MB/s
> 
> Several Parallel short read and short write operations (sum of all the
> read throughputs):
> --------------------------------------------------------------------------
> no-packing: 41.6 MB/s
> packed commands patch (both READ and WRITE packing are enabled): 35 MB/s
> packed commands patch + enabling only READ packing: 36 MB/s
> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

