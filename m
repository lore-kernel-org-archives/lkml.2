Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab1JGKda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:33:30 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:23753 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab1JGKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:33:29 -0400
Message-ID: <4E8ED574.8040609@dsn.lapis-semi.com>
Date: Fri, 07 Oct 2011 19:33:24 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_dma: Fix suspend issue
References: <1317713279-2774-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>	 <1317963658.1573.2229.camel@vkoul-udesk3>	 <4E8E940E.7040701@dsn.lapis-semi.com> <1317968080.1573.2266.camel@vkoul-udesk3>
In-Reply-To: <1317968080.1573.2266.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/07 15:14), Vinod Koul wrote:
> This is all is due to not saving nr_channels in probe and using that
> instead.
>
> Looking deeper, struct pch_dma defines array of length MAX_CHAN_NR for
> channels. Then why do you allocate memory in probe as
>           pd = kzalloc(sizeof(struct pch_dma)+
>                   sizeof(struct pch_dma_chan) * nr_channels, GFP_KERNEL);
> what is the point in allocating additional memory for each channel?
>
> Given this, why should there be predefined channel array in pcm_dma?
>
> It would be great if we could fix this by dynamically allocating memory
> for channels based on nr_channels and not wasting due to a static array.

You are right.
Current pch_dma driver looks like wasting memory.

We must review pch_dma driver again.

Thanks,
-- 
tomoya
ROHM Co., Ltd.
