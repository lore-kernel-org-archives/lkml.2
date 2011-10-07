Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab1JGFy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:54:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:16684 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab1JGFy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:54:26 -0400
Message-ID: <4E8E940E.7040701@dsn.lapis-semi.com>
Date: Fri, 07 Oct 2011 14:54:22 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_dma: Fix suspend issue
References: <1317713279-2774-1-git-send-email-tomoya-linux@dsn.lapis-semi.com> <1317963658.1573.2229.camel@vkoul-udesk3>
In-Reply-To: <1317963658.1573.2229.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/07 14:00), Vinod Koul wrote:
> How would changing the max number of descriptors fix the memory
> violation?
>

In probe of pch_dma,  you can see the following code.

	for (i = 0; i < nr_channels; i++) {

snip...

		pd_chan->membase = &regs->desc[i];

snip...

	}

Max value of nr_channels is 12 defined at pci_table.
So, this caused memory access violation.

-- 
tomoya
ROHM Co., Ltd.
