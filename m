Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab2I1K6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:58:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44913 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab2I1K6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAG17yqTSj4wg0f-9kuzqYDicpD50mjZ2vuWCm+s4vfCTcQs_1g@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	<CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
	<1348739292.1648.15.camel@vkoul-udesk3>
	<CAG17yqRxZFsKpx+gpEGoZTbs4x7ijmqywX39=ezq2+RZkvk=TA@mail.gmail.com>
	<CABb+yY1qbs_s7a-rb91wehEUbO1Azax+-PCaH2QQ=gr+Mc5ioA@mail.gmail.com>
	<CAG17yqTSj4wg0f-9kuzqYDicpD50mjZ2vuWCm+s4vfCTcQs_1g@mail.gmail.com>
Date: Fri, 28 Sep 2012 16:28:40 +0530
Message-ID: <CABb+yY3QfZEyvn4jvwdbgf6OBy++XMNZoeN0zrzHrCy=f4iwzw@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMA: PL330: Balance module remove function with probe
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, boojin.kim@samsung.com,
        patches@linaro.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:03 AM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:
>
> Now, if we have to check if any client is using the channel and then
> decide. We will have to traverse the channel list twice once to check
> the usage and second time to delete the nodes from the list if we go
> ahead with remove.
> The remove will look like below:
>
> @@ -3008,18 +3008,19 @@ static int __devexit pl330_remove(struct
> amba_device *adev)
>         if (!pdmac)
>                 return 0;
>
> +       /* check if any client is using any channel */
> +       list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
> +                       chan.device_node) {
> +
> +               if (pch->chan.client_count)
> +                       return -EBUSY;
> +       }
> +
The iteration doesn't have to be the 'safe' version here. Other than
that it seems OK.
