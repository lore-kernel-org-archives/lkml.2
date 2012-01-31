Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2AaM5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:57:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47077 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2AaM5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:57:32 -0500
MIME-Version: 1.0
In-Reply-To: <1328008455.956.30.camel@sauron.fi.intel.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com> <1328008455.956.30.camel@sauron.fi.intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 31 Jan 2012 20:57:11 +0800
Message-ID: <CAGsJ_4yVTaZQOE2dB4A3L6WCLE78b4eBPaOcDDJ7RH+0LN=R_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] platform: add platform_devm_request_and_ioremap()
 common API
To: dedekind1@gmail.com
Cc: Barry Song <Barry.Song@csr.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

2012/1/31 Artem Bityutskiy <dedekind1@gmail.com>:
> On Tue, 2012-01-31 at 17:59 +0800, Barry Song wrote:
>> these patches move the common pattern from
>>
>> "
>> res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> if (!res) {
>>               ret = -ENODEV;
>>                       goto err;
>> }
>>
>> base = devm_request_and_ioremap(&dev->dev, mem_res);
>> if (!base) {
>>               ret = -ENODEV;
>>                       goto err;
>> }
>> "
>
> Am I right that these patches have been generated using the
> coccinelle/api/devm_request_and_ioremap.cocci script?
>
> If yes, I think it would be nice of you to give a credit to coccinelle
> and its authors for developing this awesome tool in every commit
> message.

devm_request_and_ioremap() is still something new by commit
72f8c0bfa0de64c68ee59f40eb9b2683bffffbb0:
author	Wolfram Sang <w.sang@pengutronix.de>	
	Tue, 25 Oct 2011 13:16:47 +0000 (15:16 +0200)

there are only a few users until now. but it is going to be used as a
common/suggested way to request and map resource. now we don't need a
script to find them, just cscope "cs f c devm_request_and_ioremap".

>
> --
> Best Regards,
> Artem Bityutskiy

-barry
