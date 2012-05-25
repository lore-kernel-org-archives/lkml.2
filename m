Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2EYIbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:31:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59195 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab2EYIba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <1337932567.1580.4.camel@vkoul-udesk3>
References: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
	<4FBDB812.9060407@linaro.org>
	<CAJe_ZhfV6F-X7+M+NYoH4cG1WWU45MTpHsUiWtK406nhjLPHRg@mail.gmail.com>
	<1337932567.1580.4.camel@vkoul-udesk3>
Date: Fri, 25 May 2012 14:01:29 +0530
Message-ID: <CAJuYYwSX-Z6ewapWbXZ6Y3ouT=W6Dk6WNDw_UFmEPZnmd4to7A@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: pl330: dont complete descriptor for cyclic dma
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 May 2012 13:26, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> On Thu, 2012-05-24 at 10:34 +0530, Jassi Brar wrote:
>> On 24 May 2012 09:54, Tushar Behera <tushar.behera@linaro.org> wrote:
>> > Forgot to add driver author in the original mail, adding now.
>> >
>> > On 05/23/2012 04:47 PM, Tushar Behera wrote:
>> >> Commit eab215855803 ("dmaengine: pl330: dont complete descriptor for
>> >> cyclic dma") wrongly completes descriptor for cyclic dma, hence following
>> >> BUG_ON is still hit with cyclic DMA operations.
>> >>
>> >> kernel BUG at drivers/dma/dmaengine.h:53!
>> >>
>> >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> >> ---
>> >>  drivers/dma/pl330.c |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> >> index fa3fb21..8c44f17 100644
>> >> --- a/drivers/dma/pl330.c
>> >> +++ b/drivers/dma/pl330.c
>> >> @@ -2322,7 +2322,7 @@ static void pl330_tasklet(unsigned long data)
>> >>       /* Pick up ripe tomatoes */
>> >>       list_for_each_entry_safe(desc, _dt, &pch->work_list, node)
>> >>               if (desc->status == DONE) {
>> >> -                     if (pch->cyclic)
>> >> +                     if (!pch->cyclic)
>> >>                               dma_cookie_complete(&desc->txd);
>> >>                       list_move_tail(&desc->node, &list);
>> >>               }
>> >
>> Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
>>
>> Obviously a typo, but the commit eab2158 had a tested-by, so I hope
>> this doesn't break something else.
> Precisely my worry as well. Thomas?

I am not sure what I have missed here. Since it was a simple change, I
think I manually edited the code for the test. I apologize for the
mistake in the test.

Regards,
Thomas.

>
> >From the code this looks as the right one.
>
> --
> ~Vinod
>
