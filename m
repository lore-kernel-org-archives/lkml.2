Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679Ab0HFSeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:34:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47264 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322Ab0HFSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kxJ13PX3LmFeZRnlE9kV7KOADZB6b2cyMh39cS6W8zNPmutosi6acpSbLV0LYfy03U
         2yDRZbb3jb02zW3gwmv46npaCaq+iG5EKJGNX5o2MoSfN+a9/QvbUlj3/H66DEcFr8lX
         W1NRiWYBG24aWiETqjNnDsvES4bGnRmPs3kYs=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=OLP+NwGP7v0O0=ZqBNp_Ag9mm+LEUnCw5OX7L@mail.gmail.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
	<AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
	<AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
	<AANLkTi=yJjHDh08muCg7Z97xRGDcTQrv=VimHSNCqn2U@mail.gmail.com>
	<20100805071235.GA436@morgana.i.gnudd.com>
	<AANLkTinAuZ5GAauKHfUVV_K_9gQOpFY35m7SLsH6rvD1@mail.gmail.com>
	<AANLkTi=OLP+NwGP7v0O0=ZqBNp_Ag9mm+LEUnCw5OX7L@mail.gmail.com>
Date: Fri, 6 Aug 2010 11:34:16 -0700
X-Google-Sender-Auth: 1Mea05U6vjcuEEVI3LdT4uBrQp0
Message-ID: <AANLkTi=9BjWWdcZg0w772jcemjriQ5p0HV3EJB8OM68O@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Alessandro Rubini <rubini@unipv.it>, peter.pearse@arm.com,
        viresh.kumar@st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yuanyabin1978@sina.com,
        ben-linux@fluff.org, kgene.kim@samsung.com, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 10:54 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Aug 5, 2010 at 12:30 AM, Linus Walleij
> <linus.ml.walleij@gmail.com> wrote:
>> 2010/8/5 Alessandro Rubini <rubini@unipv.it>:
>>
>>>> Peter, Alessandro and Viresh especially: you will hopefully use this
>>>> driver for ARM refboards, Nomadik and SPEAr, can you provide
>>>> an Acked-by:?
>>>
>>> I'm sorry I can't test it these times, I must delay stuff to
>>> the last week of August.
>>
>> That's be a Tested-by: tag, Acked-by: was more about whether you
>> think it looks sane I believe, see Documentation/SubmittingPatches.
>
> We have the Acked-by from Viresh, Alessandro looks like he is
> interested in trying it out, the driver is self contained, marked
> experimental, and you have a track-record of fixing things up, so I'll
> include it with the idea it will be easier to fixup in-tree.

...except this version no longer compiles:

drivers/dma/amba-pl08x.c: In function 'dma_set_runtime_config':
drivers/dma/amba-pl08x.c:1399: error: 'struct dma_slave_config' has no
member named 'maxburst'
drivers/dma/amba-pl08x.c:1405: error: 'struct dma_slave_config' has no
member named 'addr'
drivers/dma/amba-pl08x.c:1408: error: 'struct dma_slave_config' has no
member named 'addr_width'
drivers/dma/amba-pl08x.c:1464: error: 'struct dma_slave_config' has no
member named 'addr_width'
drivers/dma/amba-pl08x.c:1464: error: 'struct dma_slave_config' has no
member named 'maxburst'

Fix that up and we can try to get it in the second half of the merge window.

--
Dan
