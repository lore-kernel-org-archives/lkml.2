Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2ISQDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:03:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:61320 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab2ISQC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="146779757"
Date: Wed, 19 Sep 2012 18:02:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rickard Andersson <rickard.andersson@stericsson.com>
Subject: Re: [PATCH 3/4] mfd: dbx500: Provide a more accurate smp_twd clock
Message-ID: <20120919160251.GM28670@sortiz-mobl>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
 <1346415691-13371-4-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346415691-13371-4-git-send-email-ulf.hansson@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Fri, Aug 31, 2012 at 02:21:30PM +0200, Ulf Hansson wrote:
> From: Michel Jaouen <michel.jaouen@stericsson.com>
> 
> The local timer clock is based on ARM subsystem clock. This patch
> obtains a more exact value of that clock by reading PRCMU registers.
> Using this increases the accuracy of the local timer events.
> 
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
> Signed-off-by: Michel Jaouen <michel.jaouen@stericsson.com>
> ---
>  drivers/mfd/db8500-prcmu.c       |   42 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/dbx500-prcmu-regs.h  |    4 +++-
>  include/linux/mfd/dbx500-prcmu.h |    1 +
>  3 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 4f74529..e7f9539 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -418,6 +418,9 @@ static struct {
>  
>  static atomic_t ac_wake_req_state = ATOMIC_INIT(0);
>  
> +/* Functions definition */
> +static void compute_armss_rate(void);
> +
I'm not a big fan of forward declarations, but I still applied your patch to
my for-next branch. Thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
