Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab1BWT1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:27:09 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab1BWT1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:27:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CdVKji0/97UMHzVSQiMLVgSHNLPtn7q8NDSs9FmyIxiMaLiHjR9+LAT2ZaI+jZjF8e
         phneeMAt+gXjfgkLvoRw==
MIME-Version: 1.0
In-Reply-To: <20110223002059.GV15795@trinity.fluff.org>
References: <AANLkTim0X=gUwYJmR+EAYjGamiJb7tgiVEjwqCEF0-L0@mail.gmail.com>
	<1298250861-27094-1-git-send-email-ccross@android.com>
	<20110223002059.GV15795@trinity.fluff.org>
Date: Wed, 23 Feb 2011 11:26:42 -0800
X-Google-Sender-Auth: 1Wtoy8ZqeT14KyqFpEW5ls1B3lI
Message-ID: <AANLkTi=wtxzKGHXgtoUsV8J4O3NUYdz9PGHi-sdd-Osy@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: tegra: Add i2c support
From: Colin Cross <ccross@android.com>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        swarren@nvidia.com, patches@opensource.wolfsonmicro.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 4:20 PM, Ben Dooks <ben-i2c@fluff.org> wrote:
> On Sun, Feb 20, 2011 at 05:14:21PM -0800, Colin Cross wrote:
>> Adds I2C bus driver for nVidia Tegra SoCs.  Tegra includes 4 I2C
>> controllers, one of which is inside the Dynamic Voltage Controller
>> and has a slightly different register map.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Would have been helpful to start a new thread, missed this the first time
> around.
>
>> +     i2c_dev = kzalloc(sizeof(struct tegra_i2c_dev), GFP_KERNEL);
>> +     if (!i2c_dev) {
>
> no error print here.
>
>> +             ret = -ENOMEM;
>> +             goto err_i2c_clk_put;
>> +     }
>
>> +     if (pdev->id == 3)
>> +             i2c_dev->is_dvc = 1;
>> +     init_completion(&i2c_dev->msg_complete);
>
> you might want to think about having a seperate platform bus name for
> this case, and switching the is_dvc field on that. It'll make life much
> easier if someone decides that what the next tegra i2c needs is 5 i2c
> controllers.
>
> I'll consider putting this (as is) into the -next tree, but would like
> to see the issues with readsl/writesl sorted out and any other review
> comments sorted.
>
Thanks for merging it.  Can I merge your i2c-tegra tree into the tegra
for-next tree to allow some board changes that depend on the header to
go on top?
