Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0HWGxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:53:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39385 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0HWGxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=p8e6UNImLtrE9lYsM0R14sD9qbD8DG7yh397Vbp7971XRLb0nXW/H73ex/fdNqRmTD
         g1oWByj+hTMbG7cjbs4grpoqfnU+k0Yh25Zq27wToBcFV7ZLYuIODGS13UXHIukWpwEA
         5eUeSD2nC3S59c4rWyp7kJZ4RGIr7vELT1FhQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinuFrE0ZpTpgaEQr5GYFXzGjHYq7FC-sY-UiVFi@mail.gmail.com>
References: <20100818083346.GA6308@july>
	<AANLkTinuFrE0ZpTpgaEQr5GYFXzGjHYq7FC-sY-UiVFi@mail.gmail.com>
Date: Mon, 23 Aug 2010 15:53:49 +0900
X-Google-Sender-Auth: XZQRkvnV6Fa0WksBc9zDTGeMIm4
Message-ID: <AANLkTimyC2PcTgEbeKNQTCobxEKj-+wMViEOhNfE6JTg@mail.gmail.com>
Subject: Re: [PATCH] Ramoops: use the platform data structure instead of
 module params
From: Kyungmin Park <kmpark@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 3:48 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> 2010/8/18 Kyungmin Park <kmpark@infradead.org>:
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> As each board and system has different memory for ramoops. It's better to define the platform data instead of module params.
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>
> It seems good. Currently there isn't any code that register a ramoops
> device, isn't it?

At this time

I wrote it below

static struct ramoops_platform_data goni_ramoops_data = {
        .mem_size               = SZ_16K,
        .mem_address            = 0xED000000,   /* MODEM SRAM */
};

static struct platform_device goni_ramoops = {
        .name = "ramoops",
        .dev = {
                .platform_data = &goni_ramoops_data,
        },
};

Thank you,
Kyungmin Park
