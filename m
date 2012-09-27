Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2I0QG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:06:28 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37988 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2I0QG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:06:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAG17yqRxZFsKpx+gpEGoZTbs4x7ijmqywX39=ezq2+RZkvk=TA@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	<CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
	<1348739292.1648.15.camel@vkoul-udesk3>
	<CAG17yqRxZFsKpx+gpEGoZTbs4x7ijmqywX39=ezq2+RZkvk=TA@mail.gmail.com>
Date: Thu, 27 Sep 2012 21:36:25 +0530
Message-ID: <CABb+yY1qbs_s7a-rb91wehEUbO1Azax+-PCaH2QQ=gr+Mc5ioA@mail.gmail.com>
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

On Thu, Sep 27, 2012 at 9:11 PM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:
> On 27 September 2012 15:18, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>> On Wed, 2012-09-26 at 12:11 +0530, Inderpal Singh wrote:
>>> If we fail pl330_remove while some client is queued, the force unload
>>> will fail and the
>>> force unload will lose its purpose.
>>> How about conditionally DMA_TERMINATE_ALL and free resources like
>>> below ?
>> Why would you want to remove the driver when it is doing something
>> useful? You have to ensure driver is not doing anything.
>>
>> What is point here?
>>
> As mentioned by jassi,  if the pl330 module is forced unloaded while
> some client is queued, we have to manually do DMA_TERMINATE_ALL.
>
I meant that in the current situation. Not ideally.

> If failing remove is a better option in case some client is queued, we
> can do away with DMA_TERMINATE_ALL and free_chan_resources and simply
> return a suitable error code from remove.
>
That was exactly what I suggested as an alternative.
