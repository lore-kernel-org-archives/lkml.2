Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1JJLQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:16:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59928 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1JJLQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <1318243501.1546.12.camel@vkoul-udesk3>
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
	<1317997177.1573.2275.camel@vkoul-udesk3>
	<CAJe_ZhdSRmQmHOyOSvzyduu1pxR5K3aSd+1fCW2TB36=1ZwUUg@mail.gmail.com>
	<1318229592.1573.2298.camel@vkoul-udesk3>
	<CAJe_ZhcWUjdh-LGuAaDAbSYNYrV5dzsrkpCGCeYo6y38pNac4g@mail.gmail.com>
	<1318238296.1546.3.camel@vkoul-udesk3>
	<CAJe_ZheDWAeisyOxFVmhWgZCi5qx8QL1_L+YttFrzWxSHyceug@mail.gmail.com>
	<1318243501.1546.12.camel@vkoul-udesk3>
Date: Mon, 10 Oct 2011 16:46:08 +0530
Message-ID: <CAJe_Zhd0xVULcEd2t5DwofmjPNrxOi3bUjMVDRF5N4+47kUiJw@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 October 2011 16:15, Vinod Koul <vinod.koul@intel.com> wrote:
>
> But I am fine if we find a common ground and merge the two where dmac
> can cleanly identify direction and mode it is operating.
>
The client would set the xfer_direction and dmac would interpret as

enum xfer_direction {
     MEM_TO_MEM,   ->  Async/Memcpy mode
     MEM_TO_DEV,    ->  Slave mode & From Memory to Device
     DEV_TO_MEM,    ->  Slave mode & From Device to Memory
     DEV_TO_DEV,     ->  Slave mode & From Device to Device
}

How could it get any cleaner?
