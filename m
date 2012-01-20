Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2ATEfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 23:35:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33034 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab2ATEf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 23:35:28 -0500
MIME-Version: 1.0
In-Reply-To: <002501ccd728$baca1010$305e3030$%jun@samsung.com>
References: <002501ccd728$baca1010$305e3030$%jun@samsung.com>
Date: Fri, 20 Jan 2012 13:35:27 +0900
X-Google-Sender-Auth: MuiW2S6wvVYazMFTc0IJFRpyewo
Message-ID: <CAH9JG2VNSUNYAqd9MUawf4a5Q6HfjE07KOOZ5dkYnzzuzc0KrA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] mmc: core: Support packed command feature of eMMC4.5
From: Kyungmin Park <kmpark@infradead.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI: we get performance gain using packed command at write. however in
case of small size read, there are some performance drop since
protocol overhead.
In normal case, read command uses read operation only, but in case of
packed read. It sends the command to eMMC and read it.
Anyway it's good feature for eMMC v4.5.

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On 1/20/12, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> This patch-set adds support of packed command feature
> for eMMC4.5 devices.
>
> Changes in v3:
> 	- Add a variable member in mmc_host for minimum number of packed entries.
> 	  This value can be overrided by host.
> 	- Fix a handling of error sequence.
>
> Changes in v2:
> 	- Fix the packed read sequence and error handling.
> 	- Apply checking the exception status for all cases with
> 	  the comments from Maya Erez and Sahitya Tummala.
> 	- Fix preparing the packed list with the comment from Maya Erez and
> Venkatraman.
>
>
> Seungwon Jeon (2):
>       mmc: core: Add packed command feature of eMMC4.5
>       mmc: core: Support packed command for eMMC4.5 device
>
>  drivers/mmc/card/block.c   |  469
> +++++++++++++++++++++++++++++++++++++++++---
>  drivers/mmc/card/queue.c   |   48 +++++-
>  drivers/mmc/card/queue.h   |   13 ++
>  drivers/mmc/core/host.c    |    2 +
>  drivers/mmc/core/mmc.c     |   24 +++
>  drivers/mmc/core/mmc_ops.c |    1 +
>  include/linux/mmc/card.h   |    3 +
>  include/linux/mmc/core.h   |    3 +
>  include/linux/mmc/host.h   |    4 +
>  include/linux/mmc/mmc.h    |   15 ++
>  10 files changed, 555 insertions(+), 27 deletions(-)
>
> Best regards,
> Seungwon Jeon.
> --
> 1.7.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
