Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2FFRQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:16:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38141 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2FFRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:16:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6733"; a="198355575"
Message-ID: <4FCF9053.6020102@codeaurora.org>
Date: Wed, 06 Jun 2012 10:16:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, keescook@chromium.org,
        marco.stornelli@gmail.com, grant.likely@secretlab.ca,
        anton.vorontsov@linaro.org
Subject: Re: [PATCH] pstore/ram: Add ramoops support for the Flattened Device
 Tree.
References: <1338926395-26298-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1338926395-26298-1-git-send-email-bfreed@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/12 12:59, Bryan Freed wrote:
> When called with a non-zero of_node, fill out a new ramoops_platform_data
> with data from the specified Flattened Device Tree node.
> Update ramoops documentation with the new FDT interface.
>
> Change-Id: Id8f9f0abc5b564375c1b6d5d30c92d57d76520b7
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
> ---
>  Documentation/ramoops.txt |   19 +++++++++++++++++--
>  fs/pstore/ram.c           |   43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+), 2 deletions(-)

Can you document the binding in Documentation/devicetree/bindings/* too?

> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 9123cce..bf0f882 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -213,6 +248,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
>  	if (cxt->max_count)
>  		goto fail_out;
>  
> +	if (pdev->dev.of_node) {
> +		if (of_ramoops_platform_data(pdev->dev.of_node, &of_pdata)) {
> +			pr_err("Invalid ramoops device tree data\n");

dev_err()?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

