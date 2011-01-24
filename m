Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1AXWhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:37:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26516 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1AXWhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:37:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71814124"
Subject: Re: [PATCH v2 02/11] msm: Generalize timer register mappings
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1295468747-22796-3-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-3-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 14:36:44 -0800
Message-ID: <1295908604.29639.62.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
> +       int global_offset = 0;
> +
> +       if (cpu_is_msm7x01()) {
> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
> +       } else if (cpu_is_msm7x30()) {
> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE + 0x04;
> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x24;
> +       } else if (cpu_is_qsd8x50()) {
> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
> +       } else if (cpu_is_msm8x60()) {
> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_TMR_BASE + 0x04;
> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_TMR_BASE + 0x24;
> +
> +               /* Use CPU0's timer as the global timer. */
> +               global_offset = MSM_TMR0_BASE - MSM_TMR_BASE;
> +       } else
> +               BUG(); 

Ifdef's here would be OK I think, your already using the "runtime"
checks ..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

