Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab1EYHrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:47:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39514 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab1EYHrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:47:32 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikjxECNAK5eS5hSu2bbEKpZX341Dw@mail.gmail.com>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
	<BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
	<1306253171.30236.9.camel@vkoul-udesk3>
	<BANLkTikjxECNAK5eS5hSu2bbEKpZX341Dw@mail.gmail.com>
Date: Wed, 25 May 2011 09:47:31 +0200
Message-ID: <BANLkTikAm=D_YNFt0Regeas6AX8116L0-A@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: Per Forlin <per.forlin@linaro.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2011 23:03, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, May 24, 2011 at 9:06 AM, Koul, Vinod <vinod.koul@intel.com> wrote:
>> On Tue, 2011-05-24 at 17:40 +0200, Per Forlin wrote:
>>> Hi Vinod,
>>>
>>> On Tue, May 24, 2011 at 2:04 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
>>> > From: Vinod Koul <vinod.koul@intel.com>
>>> >
>>> > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
>>> > ---
>>> >  Documentation/dma-slave-api.txt |   74 +++++++++++++++++++++++++++++++++++++++
>>> >  1 files changed, 74 insertions(+), 0 deletions(-)
>>> >  create mode 100644 Documentation/dma-slave-api.txt
>>> I suggest putting this in subsection of dmaengine.txt instead.
>>> dmaengine.txt would be the natural place to look at.
>> Agreed, that would make it easier for people to find
>>
>>> > +4. Submit the transaction(s) and wait for callback notification when slave API
>>> > +is 3 above returns, the non NULL value would imply a "descriptor" for the
>>> > +transaction. These transaction(s) would need to be submitted which pushes them
>>> > +into queue in DMA driver. If DMA is idle then the first descriptor submit will
>>> > +be pushed to DMA and subsequent ones will be queued. On completion of the DMA
>>> > +operation the next in queue is submitted and a tasklet triggered. The tasklet
>>> > +would then call the client driver completion callback routine for notification,
>>> > +if set.
>>> > +
>>> Does submit really start the transfer as well? My interpretation of
>>> submit is that is only adds desc to a pending queue. When calling
>>> issue_pending all these descs will be schedule for DMA transfer. Calls
>>> to submit after this point will added to the pending queue again and
>>> not be issued until calling issue_pending once more.
>> For slave dma devices, submit() is used to start the transaction if the
>> channel is idle. If its already doing a transaction then it will queue
>> it up and submit once cureent excuting one is completed. It is not
>> required to call issue_pending once more.
>> I am not sure if this is true for non slave usage, Dan would that be
>> correct for you as well?
>
> No, ->submit() is just an "add this descriptor to the chain"
> operation, and ->issue_pending() is always required to make sure the
> everything submitted previously is actively executing.  This was a
> holdover from the very first dmaengine implementation where, for
> efficiency reasons, it could save mmio writes by batching the issuing
> of requests.
Thanks Dan for clarifying.
Vinod, I propose that the submit and issue_pending works the same for
SLAVE and none SLAVE channels. The API should have the same definition
independent of DMA_CAP. Please enlighten me if there are things I have
foreseen on this matter.

Thanks,
Per
