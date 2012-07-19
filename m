Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2GSMim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:38:42 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46652 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2GSMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:38:40 -0400
From: Oliver Neukum <oliver@neukum.org>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/mmc/host: Add realtek sdmmc interface driver
Date: Thu, 19 Jul 2012 14:26:36 +0200
Message-ID: <1752528.JW0yMAA2dq@linux-lqwf.site>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc6-117-g918227b-1-vanilla; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1342691718-23199-1-git-send-email-wei_wang@realsil.com.cn>
References: <1342691718-23199-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2012 17:55:18 wei_wang@realsil.com.cn wrote:

> +static void sd_normal_rw(struct realtek_sdmmc *host, struct mmc_request *mrq)
> +{
> +	struct mmc_command *cmd = mrq->cmd;
> +	struct mmc_data *data = mrq->data;
> +	u8 _cmd[5], *buf;
> +
> +	_cmd[0] = 0x40 | (u8)cmd->opcode;
> +	_cmd[1] = (u8)(cmd->arg >> 24);
> +	_cmd[2] = (u8)(cmd->arg >> 16);
> +	_cmd[3] = (u8)(cmd->arg >> 8);
> +	_cmd[4] = (u8)cmd->arg;

Please use the predefined macro for endianness conversion.

> +	buf = kzalloc(data->blksz, GFP_KERNEL);

1. You must handle a failure to allocate a buffer
2. You must use GFP_NOIO as you are in a block driver

	Regards
		Oliver

