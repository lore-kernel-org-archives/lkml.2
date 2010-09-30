Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab0I3HkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:40:10 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:51869 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830Ab0I3HkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:40:08 -0400
Message-ID: <4CA438B4.4040106@stericsson.com>
Date: Thu, 30 Sep 2010 09:13:56 +0200
From: Per Friden <per.friden@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Per FORLIN <per.forlin@stericsson.com>
Subject: Re: [PATCH 4/4] ste_dma40: implement support for scatterlist to scatterlist
 copy
References: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>	<1285628277-26894-5-git-send-email-iws@ovro.caltech.edu> <AANLkTinYG4LqtEXxM5pdA0vavahtqbt6=yV341pnFmZw@mail.gmail.com>
In-Reply-To: <AANLkTinYG4LqtEXxM5pdA0vavahtqbt6=yV341pnFmZw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 11:19 PM, Dan Williams wrote:
> On Mon, Sep 27, 2010 at 3:57 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
>> Now that the DMAEngine API has support for scatterlist to scatterlist
>> copy, implement support for the STE DMA40 DMA controller.
>>
>> Cc: Linus Walleij <linus.ml.walleij@gmail.com>
>> Cc: Per Fridén <per.friden@stericsson.com>
>> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
>> ---
>>  drivers/dma/ste_dma40.c |   17 +++++++++++++++++
>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
>> index 17e2600..cd48859 100644
>> --- a/drivers/dma/ste_dma40.c
>> +++ b/drivers/dma/ste_dma40.c
>> @@ -1857,6 +1857,18 @@ err:
>>        return NULL;
>>  }
>>
>> +static struct dma_async_tx_descriptor *
>> +d40_prep_sg(struct dma_chan *chan,
>> +           struct scatterlist *dst_sg, unsigned int dst_nents,
>> +           struct scatterlist *src_sg, unsigned int src_nents,
>> +           unsigned long dma_flags)
>> +{
>> +       if (dst_nents != src_nents)
>> +               return -EINVAL;
> 
> I suspect you wanted "return NULL;" here.  I can fix that up.
> 
> Linus, Per ack?
> 
> --
> Dan
Thanks Dan. Acked by Per.

/Per
