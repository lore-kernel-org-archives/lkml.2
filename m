Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1AYSMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:12:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14480 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1AYSMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:12:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71931500"
Subject: Re: [PATCH v2 02/11] msm: Generalize timer register mappings
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1295468747-22796-3-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-3-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 25 Jan 2011 10:12:16 -0800
Message-ID: <1295979136.16668.4.camel@carlv-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
> -#define MSM_GPT_PHYS          MSM_CSR_PHYS
> -#define MSM_GPT_BASE          MSM_CSR_BASE
> -#define MSM_GPT_SIZE          SZ_4K
...
> +#define MSM_CHIP_DEVICE(name, chip) {			      \
>  		.virtual = (unsigned long) MSM_##name##_BASE, \
> -		.pfn = __phys_to_pfn(MSM_##name##_PHYS), \
> -		.length = MSM_##name##_SIZE, \
> +		.pfn = __phys_to_pfn(chip##_##name##_PHYS), \
> +		.length = chip##_##name##_SIZE, \
>  		.type = MT_DEVICE_NONSHARED, \
>  	 }
>  
> +#define MSM_DEVICE(name) MSM_CHIP_DEVICE(name, MSM)
> +
>  #if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27) \
>  	|| defined(CONFIG_ARCH_MSM7X25)
>  static struct map_desc msm_io_desc[] __initdata = {
>  	MSM_DEVICE(VIC),
> -	MSM_DEVICE(CSR),
> +	MSM_CHIP_DEVICE(CSR, MSM7X00),
>  	MSM_DEVICE(GPT),
>  	MSM_DEVICE(DMOV),
>  	MSM_DEVICE(GPIO1),

MSM_DEVICE(GPT) still references MSM_GPT_PHYS, MSM_GPT_SIZE and
MSM_GPT_BASE on the 7x00a though they are being removed.

---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.

