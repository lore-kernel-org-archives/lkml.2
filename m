Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2K0GWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:22:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:53892 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963Ab2K0GWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:22:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,326,1352102400"; 
   d="scan'208";a="172974127"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: Dan Williams <djbw@fb.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioat: remove chanerr mask setting for IOAT v3.x
Thread-Topic: [PATCH] ioat: remove chanerr mask setting for IOAT v3.x
Thread-Index: AQHNzFuGDwLbTVc0eU2Gjp5sVbxJLpf9Nkkl
Date: Tue, 27 Nov 2012 06:21:57 +0000
Message-ID: <9460C9B6-F861-4822-8576-508BB627CF70@intel.com>
References: <20121116232638.1766.86886.stgit@djiang5-linux.ch.intel.com>,<CAA9_cmfYpa+ByFDJNwqxsj+e_3xrZD-=EP-NGQmWuWjgc7ZRtw@mail.gmail.com>
In-Reply-To: <CAA9_cmfYpa+ByFDJNwqxsj+e_3xrZD-=EP-NGQmWuWjgc7ZRtw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 26, 2012, at 9:56 PM, "Dan Williams" <djbw@fb.com> wrote:

> On Fri, Nov 16, 2012 at 3:26 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>> The CHANERRMSK_INT register should be 0. The existing code set a value
>> for a workaround to address a pre-silicon bug on the Intel 5520 IO hub that
>> has been fixed when the hardware was released. There is no need for this
>> code.
>> 
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> 
>> drivers/dma/ioat/dma_v3.c |    8 ++------
>> 1 file changed, 2 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
>> index f7f1dc6..60c15c4 100644
>> --- a/drivers/dma/ioat/dma_v3.c
>> +++ b/drivers/dma/ioat/dma_v3.c
>> @@ -1126,12 +1126,8 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
>>        chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>>        writel(chanerr, chan->reg_base + IOAT_CHANERR_OFFSET);
>> 
>> -       /* -= IOAT ver.3 workarounds =- */
>> -       /* Write CHANERRMSK_INT with 3E07h to mask out the errors
>> -        * that can cause stability issues for IOAT ver.3, and clear any
>> -        * pending errors
>> -        */
>> -       pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0x3e07);
>> +       /* clearn CHANERRMASK_INT and clear any pending errors */
>> +       pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0);
> 
> Can we get rid of this write / register access altogether?  Then the
> driver will load on systems where extended pci configuration space is
> not available.

Yes I will generate new patch. 