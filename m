Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373Ab1JGFw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:52:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:17127 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab1JGFw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60797239"
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 11:15:46 +0530
Message-ID: <1317966346.1573.2252.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 11:14 -0700, Williams, Dan J wrote:
> This new operation type strikes me as being in a similar vein to
> commit a08abd8c "async_tx: structify submission arguments, add
> scribble", in that we convert multiple submission arguments into one
> description template.  With some tweaks it could probably even cover
> the DMA_CYCLIC, but probably could not cover the raid ops.  In general
> I'm concerned about operation type proliferation, so if we added this
> one I'd like to see others removed. 
For slave cases, we have DMA_SLAVE, DMA_CYCLIC and some support memcpy
as well.

I think we should have kept DMA_CYCLIC as a special case of DMA_SLAVE
(thru a flag perhaps) not a new API, if all agree i can fix that up for
3.3

Thru this patch Jassi gave a very good try at merging DMA_SLAVE and
memcpy, but more we debate this, I am still not convinced about merging
memcpy and DMA_SLAVE yet.

I would still argue that if we split this on same lines as current
mechanism, we have clean way to convey all details for both cases.

maybe I am being pessimist, but my vote goes for simpler things

Thoughts...?

For other memcpy cases like xor, etc, I don't think I have looked at
finer detail to comment on it, but if we can make a generic mempy API
with ops specified for what "type" of memcpy we could reduce it :)

-- 
~Vinod

