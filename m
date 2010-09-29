Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0I2Wjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:39:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41941 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0I2Wjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L8vstSYF7Vnlx8DFILabDpR95JkhLj8ZNV4kRFfAsCLHincIW6IwZsB515HZ/MfKTk
         9XcRU5QGzni3CDLGSkOJV7nkR3R0Ny0+YjwfYkG35VZQw8aMFKe7F0XqgExhhAGQCa7W
         Mz6p7Gw7vVUCByKX6xxIMMw3bz18G+uIU+R3E=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=b-Wzp4-0vg_AVz0os08dC7hX6gZBQn8WHfcF5@mail.gmail.com>
References: <1285682257-16482-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=b-Wzp4-0vg_AVz0os08dC7hX6gZBQn8WHfcF5@mail.gmail.com>
Date: Thu, 30 Sep 2010 00:39:41 +0200
X-Google-Sender-Auth: PpZANbtogQ6-T-qOzzphzP0s6gs
Message-ID: <AANLkTi=cvg6YKaEqOOCjBu2gc__k7470t1rdF9gvBsR4@mail.gmail.com>
Subject: Re: [PATCH] driver for the ARM PL080/PL081 PrimeCells v5
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Peter Pearse <peter.pearse@arm.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/29 Dan Williams <dan.j.williams@intel.com>:
> [Me]
>> +/*
>> + * Initialize a descriptor to be used by memcpy submit
>> + */
>> +static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
>> +               struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>> +               size_t len, unsigned long flags)
>> +{
>> +       struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
>> +       struct pl08x_driver_data *pl08x = plchan->host;
>> +       struct pl08x_txd *txd;
>> +       int ret;
>> +
>> +       txd = kzalloc(sizeof(struct pl08x_txd), GFP_KERNEL);
>> +       if (!txd) {
>> +               dev_err(&pl08x->adev->dev,
>> +                       "%s no memory for descriptor\n", __func__);
>> +               return NULL;
>> +       }
>
> With your acknowledgment I'll append a patch to convert this to
> GFP_NOWAIT because device_prep_dma_memcpy() is meant to be callable
> from atomic contexts.

Damn typically I forgot something. Please go ahead with this!
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
