Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1I1JTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:19:03 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:32976 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1I1JTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:19:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAOY=C6ESgRpdCYb8tCxmmdRGfjv+gqroDNiq63zyRjardVicjQ@mail.gmail.com>
References: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
	<CAOY=C6ESgRpdCYb8tCxmmdRGfjv+gqroDNiq63zyRjardVicjQ@mail.gmail.com>
Date: Wed, 28 Sep 2011 11:18:59 +0200
Message-ID: <CACRpkdZ+39R2fTTUgnqhxFXqUGTfP8WGUuO9EjOVmo-YA=-TPw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v7
From: Linus Walleij <linus.walleij@linaro.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:30 AM, Stijn Devriendt <highguy@gmail.com> wrote:
>> +       spin_unlock(&desc->lock);
>
> Now this is racing with...
> (...)
> ... this:
>
>> +       spin_lock(&desc->lock);
>> +       desc->mux_requested = true;
>> +       strncpy(desc->mux_function, function, sizeof(desc->mux_function));
>> +       spin_unlock(&desc->lock);

Good catch!

I've fixed it by setting ->mux_requested immediatelty and then
later release it (inside a lock) if something fails.

Yours,
Linus Walleij
