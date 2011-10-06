Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935027Ab1JFHMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:12:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36516 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1JFHMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
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
Date: Thu, 6 Oct 2011 12:42:28 +0530
Message-ID: <CAJe_ZhfDK0RzSA=wiDhiXhqakp_HGbH8s5HsNEVdnCyWoLosLg@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 October 2011 23:44, Williams, Dan J <dan.j.williams@intel.com> wrote:
>
> This new operation type strikes me as being in a similar vein to
> commit a08abd8c "async_tx: structify submission arguments, add
> scribble", in that we convert multiple submission arguments into one
> description template.  With some tweaks it could probably even cover
> the DMA_CYCLIC, but probably could not cover the raid ops.  In general
> I'm concerned about operation type proliferation, so if we added this
> one I'd like to see others removed.
>
ATM this api is meant to provide a way for clients to express
interleaved (in bytes) transfers which are not possible using any
other api.

I do share your concern about operation type proliferation, and in fact
tried to make this api so that at least some prepares could be merged
in to it, but I am not sure how reasonable would it be hold this api
at ransom until other prepares are merged.
The way I see things, if we make this api generic enough we could
disallow adding more apis and merge extant ones into it one by one
at our own pace.

-j
