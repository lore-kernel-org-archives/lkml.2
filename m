Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1DPPpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 11:45:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13272 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab1DPPo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 11:44:57 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 16 Apr 2011 23:48:41 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Per Forlin <per.forlin@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 00/12] mmc: use nonblock mmc requests to minimize
 latency
Message-ID: <20110416154841.GA17935@S2100-06.ap.freescale.net>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per,

On Wed, Apr 06, 2011 at 09:07:01PM +0200, Per Forlin wrote:
[...]
> 
> Per Forlin (12):
>   mmc: add none blocking mmc request function
>   mmc: mmc_test: add debugfs file to list all tests
>   mmc: mmc_test: add test for none blocking transfers
>   mmc: add member in mmc queue struct to hold request data
>   mmc: add a block request prepare function
>   mmc: move error code in mmc_block_issue_rw_rq to a separate function.
>   mmc: add a second mmc queue request member
>   mmc: add handling for two parallel block requests in issue_rw_rq
>   mmc: test: add random fault injection in core.c
>   omap_hsmmc: use original sg_len for dma_unmap_sg
>   omap_hsmmc: add support for pre_req and post_req
>   mmci: implement pre_req() and post_req()
> 
>  drivers/mmc/card/block.c      |  493 +++++++++++++++++++++++++++--------------
>  drivers/mmc/card/mmc_test.c   |  342 ++++++++++++++++++++++++++++-
>  drivers/mmc/card/queue.c      |  171 +++++++++------
>  drivers/mmc/card/queue.h      |   31 ++-
>  drivers/mmc/core/core.c       |  132 ++++++++++-
>  drivers/mmc/core/debugfs.c    |    5 +
>  drivers/mmc/host/mmci.c       |  146 +++++++++++-
>  drivers/mmc/host/mmci.h       |    8 +
>  drivers/mmc/host/omap_hsmmc.c |   90 +++++++-
>  include/linux/mmc/core.h      |    9 +-
>  include/linux/mmc/host.h      |   13 +-
>  lib/Kconfig.debug             |   11 +
>  12 files changed, 1172 insertions(+), 279 deletions(-)
> 
I'm playing the patch set and seeing the following warnings.

  CC      drivers/mmc/card/block.o
drivers/mmc/card/block.c: In function ‘mmc_blk_issue_rq’:
drivers/mmc/card/block.c:429:6: warning: ‘status’ may be used uninitialized in this function

  CC      drivers/mmc/core/core.o
drivers/mmc/core/core.c: In function ‘mmc_request_done’:
drivers/mmc/core/core.c:163:3: warning: passing argument 2 of ‘mmc_should_fail_request’ from incompatible pointer type
drivers/mmc/core/core.c:129:20: note: expected ‘struct mmc_data *’ but argument is of type ‘struct mmc_request *’

-- 
Regards,
Shawn

