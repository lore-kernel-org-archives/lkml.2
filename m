Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1JKQoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:44:55 -0400
Received: from mga10.intel.com ([192.55.52.92]:47587 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754949Ab1JKQoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
	<CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	<1317295068.1573.1780.camel@vkoul-udesk3>
	<CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	<CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	<CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	<CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	<CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	<CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	<20111003161349.GB28287@flint.arm.linux.org.uk>
	<CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
	<CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	<1317966346.1573.2252.camel@vkoul-udesk3>
	<CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
Date: Tue, 11 Oct 2011 09:44:50 -0700
Message-ID: <CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Russell King <rmk@arm.linux.org.uk>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>, Alexandre.Bounine@idt.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding Alexandre ]

On Fri, Oct 7, 2011 at 4:27 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> On 7 October 2011 11:15, Vinod Koul <vinod.koul@intel.com> wrote:
>
>> Thru this patch Jassi gave a very good try at merging DMA_SLAVE and
>> memcpy, but more we debate this, I am still not convinced about merging
>> memcpy and DMA_SLAVE yet.
>>
> Nobody is merging memcpy and DMA_SLAVE right away.
> The api's primary purpose is to support interleave transfers.
> Possibility to merge other prepares into this is a side-effect.
>
>> I would still argue that if we split this on same lines as current
>> mechanism, we have clean way to convey all details for both cases.
>>
> Do you mean to have separate interleaved transfer apis for Slave
> and Mem->Mem ? Please clarify.
>

This is a tangent, but it would be nice if this API extension also
covered the needs of the incoming RapidIO case which wants to specify
new device context information per operation (and not once at
configuration time, like slave case).  Would it be enough if the
transfer template included a (struct device *context) member at the
end?  Most dma users could ignore it, but RapidIO could use it to do
something like:

   struct rio_dev *rdev = container_of(context, typeof(*rdev), device);

That might not be enough, but I'm concerned that making the context a
(void *) is too flexible.  I'd rather have something like this than
acquiring a lock in rio_dma_prep_slave_sg() and holding it over
->prep().  The alternative is to extend device_prep_slave_sg to take
an extra parameter, but that impacts all other slave implementations
with a dead parameter.

--
Dan
