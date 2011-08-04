Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab1HDQ7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:59:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44161 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab1HDQ7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <4E3ACF3F.4040106@freescale.com>
References: <1312454196-31028-1-git-send-email-davidb@codeaurora.org> <4E3ACF3F.4040106@freescale.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Aug 2011 17:58:42 +0100
X-Google-Sender-Auth: YIXpkZT7joY5X80EJvI0sWX48v8
Message-ID: <CACxGe6uNK5KdXH2YFMyx1A+qcRGF-XHjZhhRZmk2KEq7hJo-og@mail.gmail.com>
Subject: Re: [PATCH v2] of/address: Add of_iomap_nocache
To: Scott Wood <scottwood@freescale.com>
Cc: David Brown <davidb@codeaurora.org>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 5:56 PM, Scott Wood <scottwood@freescale.com> wrote:
>> +#ifndef SPARC
>> +extern void __iomem *of_iomap_nocache(struct device_node *device, int
>> index);
>> +#else
>> +static inline void __iomem *of_iomap_nocache(struct device_node *device,
>> +               int index)
>> +{
>> +       return of_iomap(device, index);
>> +}
>> +#endif
>
> Why is sparc special?  It looks like it defines ioremap_nocache() as
> ioremap() just like powerpc and some others, so shouldn't the normal
> of_iomap_nocache just work?

No, the implementation is completely different.  SPARC preparses all
the reg properties.  Everyone else does not.

g.
