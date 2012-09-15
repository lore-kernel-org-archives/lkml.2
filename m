Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2IOPmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:42:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50024 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab2IOPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:42:02 -0400
MIME-Version: 1.0
X-Originating-IP: [188.79.228.71]
In-Reply-To: <20120914184636.GA2976@polaris.bitmath.org>
References: <fery@cypress.com>
	<1347644917-13269-1-git-send-email-fery@cypress.com>
	<20120914184636.GA2976@polaris.bitmath.org>
Date: Sat, 15 Sep 2012 17:42:01 +0200
Message-ID: <CABxcv=n0+xywzSTiuNFMd+BvLGaNOVZVDqWYJWRXxU=DkJiYLw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Input: cyttsp4 - driver for Cypress TMA4XX
 touchscreen devices
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Ferruh Yigit <fery@cypress.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, Phil Warkentin <pwar@cypress.com>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 8:46 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Ferruh,
>
>> This driver is for Cypress TrueTouch(tm) Standard Product controllers,
>> Generation4 devices.
>>
>> This is second version of driver, code re-structured to match with
>> existing Generation3 driver code.
>
> To integrate with the existing gen3 driver is clearly not the same as
> creating a parallel set of files, which obviously share a lot of code
> with the gen3 code.
>
> For instance, the i2c transfer layer seems more or less identical to
> the existing one; just look at cyttsp_i2c_write_block_data() versus
> cyttsp4_i2c_write_block_data(). If different generations of device
> data cannot even be transported through the same _generic_ interface,
> something is clearly not right.
>
> You can't seriously expect anyone to want to maintain one set of files
> for every new version. Please make sure to build on what is already
> there.
>
> Thanks.
> Henrik
> --

Hi Ferruh,

Thanks a lot for taking the time to try to modify your driver to fit
wit the existent Gen3 driver but I agree with Henrik that it seems
that at least the transport code from the Gen3 driver could be reused.

As he said the i2c layer code is almost identical and even when there
are some differences on the spi transfer functions I think that the
current Gen3 spi transport code could be refactor to support it. These
differences seems to be only minor as far as I understood by looking
at cyttsp_spi_xfer() and cyttsp4_spi_xfer() functions.

Also it seems that you forgot to post your 1/3 patch from your series
that adds the Gen4 core driver. At least I couldn't find neither on my
mailbox nor on linux-input archives the patch:

[PATCH v2 1/3] Input: cyttsp4 - core driver for Cypress TMA4XX
touchscreen devices

So I couldn't take a look to try to figure out if the current Gen3
core driver can be extended to support the new Gen4 family or if new
core driver file is actually needed.

Best regards,
Javier
