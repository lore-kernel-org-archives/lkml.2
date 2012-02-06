Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2BFRkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:40:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46096 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848Ab2BFRkc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:40:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120206.114917.1450321525231150955.davem@davemloft.net>
References: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
	<59b9c48e067528d94b260b044e1b375c56c97040.1328445742.git.netdev@pradeepdalvi.com>
	<20120206.114917.1450321525231150955.davem@davemloft.net>
Date: Mon, 6 Feb 2012 23:10:30 +0530
Message-ID: <CA+Dx6HbHcU_Y5PSCisiRJxoKLjk_TKOef2BHHoRYGrP0Jc8oUg@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] netdev: ethernet dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 10:19 PM, David Miller <davem@davemloft.net> wrote:
> From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
> Date: Sun,  5 Feb 2012 18:20:10 +0530
>
>> From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
>>
>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>   - Removed extra skb->dev = dev after netdev_alloc_skb
>>
>> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>
>
> Applied, but again I had to fix things:
>
>> -    p = dev_alloc_skb(IEEE802_3_SZ + DE4X5_ALIGN + 2);
>> +     p = netdev_alloc_skb(dev, IEEE802_3_SZ + DE4X5_ALIGN + 2);
>  ...
>> -    p = dev_alloc_skb(len + 2);
>> +     p = netdev_alloc_skb(dev, len + 2);
>
> Leave existing indentation alone.
>
>> -             skb = dev_alloc_skb(ugeth->ug_info->uf_info.max_rx_buf_length +
>> -                                 UCC_GETH_RX_DATA_BUF_ALIGNMENT);
>> +             skb = netdev_alloc_skb(ugeth->ndev,
>> +                             ugeth->ug_info->uf_info.max_rx_buf_length +
>> +                             UCC_GETH_RX_DATA_BUF_ALIGNMENT);
>
> Line up subsequent lines of a multiline series of function arguments
> properly, each should start at the first column after the function calls
> openning parenthesis.

Thanks a lot again! And would remember about these too.
