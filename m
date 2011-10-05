Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab1JEST1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:19:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:14977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab1JESTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:19:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_Zhc2hY0dZRRZrZMzrasnvZ-+c32gB2oaGdK0mtA6GcOQew@mail.gmail.com>
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
	<CABE8wwshrNc3dmzZ+nXSA4ZXO5OgvNwEApKTGW4ieSKu_YC5sw@mail.gmail.com>
	<CAJe_Zhc2hY0dZRRZrZMzrasnvZ-+c32gB2oaGdK0mtA6GcOQew@mail.gmail.com>
Date: Wed, 5 Oct 2011 11:19:23 -0700
Message-ID: <CABE8wwvSRaJBED4E+dKo_SWAF93LA+Lqqdb1agqbMcROKxYQ8Q@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 11:23 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> You are assuming only Slave usage.
> src_inc/dst_inc are mainly for 'Memset' type operation.

There currently are not any users of offloaded memset in the kernel,
do you have one in mind?  Otherwise I would not design for it this
early.

> In Slave transfer they would help avoid allocating full length RX buffer
> when the client only wants to send data but the controller works
> only in full-duplex and vice-versa (thanks to RMK for pointing the case,
> and I remember S3C24XX do have such SPI controller).
> More generally when one needs to transmit the same data, or discard
> the received data, for a certain period of time.

In the slave case I would think the driver would know the address
increment attributes of the slave and would not need to be told on
each operation by the client?
