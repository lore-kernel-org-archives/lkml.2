Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1DQPmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 11:42:53 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:2255
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1DQPmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 11:42:46 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sun, 17 Apr 2011 23:46:23 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Per Forlin <per.forlin@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 03/12] mmc: mmc_test: add test for none blocking
 transfers
Message-ID: <20110417154622.GC17935@S2100-06.ap.freescale.net>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
 <1302116833-24540-4-git-send-email-per.forlin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1302116833-24540-4-git-send-email-per.forlin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 09:07:04PM +0200, Per Forlin wrote:
[...]
> +static int mmc_test_rw_multiple(struct mmc_test_card *test,
> +				struct mmc_test_multiple_rw *tdata,
> +				unsigned int reqsize, unsigned int size)
> +{
> +	unsigned int dev_addr;
> +	struct mmc_test_area *t = &test->area;
> +	int ret = 0;
> +	int max_reqsize = max(t->mem->size_min_cmn *
> +			      min(t->max_segs, t->mem->cnt), t->max_tfr);
> +
The 'max(..., t->max_tfr)' probably should be 'min(..., t->max_tfr)'.
Otherwise, I see mmc_test failure on my mxs-mmc setup.

mmc0: Test case 37. Write performance with blocking req 4k to 4MB...
mmc0: Transfer of 64 x 2048 sectors (64 x 1024 KiB) took 5.412563314 seconds (12
398 kB/s, 12108 KiB/s, 11.82 IOPS)
mmc0: Failed to map sg list
[mmc_test_rw_multiple] error
mmc0: Result: ERROR (-22)

-- 
Regards,
Shawn

