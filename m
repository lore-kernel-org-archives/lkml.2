Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2E2HcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:32:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab2E2HcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:32:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6725"; a="193146978"
Message-ID: <4FC47B78.2060003@codeaurora.org>
Date: Tue, 29 May 2012 00:32:08 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 03/11] pstore/ram: Factor dmesg przs initialization out
 of probe()
References: <20120526131747.GA15054@lizard> <1338038429-21945-3-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1338038429-21945-3-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2012 6:20 AM, Anton Vorontsov wrote:
> +static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
> +			      phys_addr_t *paddr, size_t dump_mem_sz)
> +{
> +	int err = -ENOMEM;
> +	int i;
> +
> +	if (!cxt->record_size)
> +		return 0;
> +
> +	cxt->max_dump_cnt = dump_mem_sz / cxt->record_size;
> +	if (!cxt->max_dump_cnt)
> +		return -ENOMEM;
> +
> +	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_cnt,
> +			     GFP_KERNEL);

kcalloc would be better but I see you're just moving code here so it
doesn't need to be changed in this patch.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

