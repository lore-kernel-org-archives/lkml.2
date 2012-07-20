Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2GTBst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:48:49 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56668 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2GTBsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:48:46 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6K1mZmN004614, This message is released by code: ctaloc0852
Message-ID: <5008B8F3.20502@realsil.com.cn>
Date: Fri, 20 Jul 2012 09:48:35 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drivers/mmc/host: Add realtek sdmmc interface driver
References: <1342691718-23199-1-git-send-email-wei_wang@realsil.com.cn> <1752528.JW0yMAA2dq@linux-lqwf.site>
In-Reply-To: <1752528.JW0yMAA2dq@linux-lqwf.site>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver:

I will fix it. Should I resend all three patches, or just this one?

BR,
Wei WANG

于 2012年07月19日 20:26, Oliver Neukum 写道:
> On Thursday 19 July 2012 17:55:18 wei_wang@realsil.com.cn wrote:
>
>> +static void sd_normal_rw(struct realtek_sdmmc *host, struct mmc_request *mrq)
>> +{
>> +	struct mmc_command *cmd = mrq->cmd;
>> +	struct mmc_data *data = mrq->data;
>> +	u8 _cmd[5], *buf;
>> +
>> +	_cmd[0] = 0x40 | (u8)cmd->opcode;
>> +	_cmd[1] = (u8)(cmd->arg >> 24);
>> +	_cmd[2] = (u8)(cmd->arg >> 16);
>> +	_cmd[3] = (u8)(cmd->arg >> 8);
>> +	_cmd[4] = (u8)cmd->arg;
> Please use the predefined macro for endianness conversion.
>
>> +	buf = kzalloc(data->blksz, GFP_KERNEL);
> 1. You must handle a failure to allocate a buffer
> 2. You must use GFP_NOIO as you are in a block driver
>
> 	Regards
> 		Oliver
>

