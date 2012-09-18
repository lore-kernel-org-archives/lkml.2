Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2IRTJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:09:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45953 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2IRTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120918194819.08538bed@pyramind.ukuu.org.uk>
References: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
	<20120918194819.08538bed@pyramind.ukuu.org.uk>
Date: Tue, 18 Sep 2012 21:09:31 +0200
Message-ID: <CAJK669aBXELfnOLNqPKher2XB01sXb24X1P5iWYYJnht3H2cQg@mail.gmail.com>
Subject: Re: [RFCv2] remoteproc: Add STE modem driver for remoteproc
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 8:48 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > +    /* make sure the offsets array isn't truncated */
>> +     if (table->num * sizeof(table->offset[0]) +
>> +         sizeof(struct resource_table) > entry->size) {
>> +             sproc_err(sproc, "resource table incomplete\n");
>> +             return NULL;
>
> None of these checks appear to be robust against maths overflow. So the
> question I'd ask is how far do you trust your inputs ?

The input is coming from user space via firmware loading framework,
so I guess it shouldn't be trusted at all. I'll try to improve these
sanity checks
in my next respin.

Thanks,
Sjur
