Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2I0GDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:03:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57059 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2I0GDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAG17yqSDi7_-VixEDfViLj0u99QBVDzePwhqswM__dp1ANpr7w@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	<CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
	<CABb+yY36pQ7oXC1OKEQ-1V55c2SZurcTAPaZ=_PWugqxdL2rgg@mail.gmail.com>
	<CAG17yqQ5NDr4sLvWbA85q5y079j2M2OV-uRjXSSL=OFPfCw3Zg@mail.gmail.com>
	<CABb+yY0dvtOZoa=T+gyTeWy3XyAictXJnqSkbF39E=peHSXDuQ@mail.gmail.com>
	<CAG17yqQbRMaaEFyTBngMwdiKVBsGaOit1ufv3t5TdwLBgSKmfw@mail.gmail.com>
	<CABb+yY0YAkaKaFRO14wYR52-Si5S=qfVczXs_2Z+jZYEpXFh2Q@mail.gmail.com>
	<CAG17yqSDi7_-VixEDfViLj0u99QBVDzePwhqswM__dp1ANpr7w@mail.gmail.com>
Date: Thu, 27 Sep 2012 11:33:10 +0530
Message-ID: <CABb+yY3iw5dWyKsdcOawMad+7L7HkyEZaHnvwQ4VUQ5Br4BoBw@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMA: PL330: Balance module remove function with probe
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        boojin.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 11:00 AM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:
> On 27 September 2012 10:35, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> On Thu, Sep 27, 2012 at 9:43 AM, Inderpal Singh
>> <inderpal.singh@linaro.org> wrote:
>>>
>>> Don't you think free_chan_resource should be done __only if__
>>> alloc_chan_resource was successful ?
>>>
>> No, I don't think so. Thanks.
>
> Thanks for quick response.
> Please elaborate more on this as I find it against the general rule
> and against the dmaengine implementation which checks on the same
> condition before proceeding for free_chan_resouces in dma_chan_put
> function.
>
I thought I already explained it, but here is the summary.
Calling pl330_free_chan_resources() for channels that have zero client
is already safe. Preventing the call by checking !client_count only
increases LOC making it uglier.

** If the new check provides any more security, please let me know. **

Food for thought : we never check for NULL before passing a pointer to
kfree(). Why ?
