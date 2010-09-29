Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0I2AfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:35:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61178 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0I2AfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u7vkKp8U+XBEu1qFuBomjihgujWKmXTu4Ps1BQFbkjs8sHEE5TibXpa69WDVJdoJFv
         JlHiH8vvXUF3Xg/dxLl8qtY3fa/ppVF+lpHaFdZ4h2cJXpsKjmbsm1CWw2eECC6obMAx
         Qy3nup6ydq33Did7iiFxGvlxFNzzm4yUDg+vw=
MIME-Version: 1.0
In-Reply-To: <4C2A145D.1000702@extricom.com>
References: <4C232B13.5000706@extricom.com>
	<20100624.145225.70206491.davem@davemloft.net>
	<4C2855D4.5050507@extricom.com>
	<20100628.113336.112593735.davem@davemloft.net>
	<4C2A145D.1000702@extricom.com>
Date: Wed, 29 Sep 2010 03:35:07 +0300
Message-ID: <AANLkTikXj3cAkrMMUP2_TGSFYQY9=oPg8QxOU-jYUjnR@mail.gmail.com>
Subject: Re: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
From: emin ak <eminak71@gmail.com>
To: Eran Liberty <liberty@extricom.com>, David Miller <davem@davemloft.net>
Cc: galak@kernel.crashing.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eran, David
This bug still exits on current both stable and rc kernel releases
reported on the mail list.
http://lkml.org/lkml/2010/9/28/178
Is there any merge plan this patch to current kernel.
Regards


2010/6/29 Eran Liberty <liberty@extricom.com>:
> David Miller wrote:
>>
>> From: Eran Liberty <liberty@extricom.com>
>> Date: Mon, 28 Jun 2010 10:57:08 +0300
>>
>>
>>>
>>> This code has proved to be insufficient and produce
>>> skb_over_panic. The proposed patch fix this.
>>>
>>
>> Then you have to post a patch relative to the current code, rather than
>> against the code as it was several releases ago.
>>
>> Your patch didn't apply, so I can't use it.
>>
>>
>
> Upon cleaning up my patch for the latest kernel I realized I do not
> like: the previous partial fix, the fix in ucc_geth.c, the fix in the
> current latest kernel, and my own previously proposed patch. They all
> tried to undo the alignment skb_reserve done in gfar_new_skb() before
> queuing the skb into the rw_recycle, because upon getting a new one in
> gfar_new_skb() if the skb is from the rx_recycle pool rather then newly
> allocated it is reserved twice.
>
> Instead of trying to undo the skb_reserve this proposed patch will make
> sure the alignment skb_reserve is done once, upon allocating the skb and
> not when taken out of the rx_recycle pool. Eliminating the need to undo
> anything before queue skb back to the pool.
>
> This patch will apply cleanly against the 2.6.32.15. Another patch will
> be submitted separately for the current Linus tree.
>
> -- Liberty
>
> Signed-off-by: Eran Liberty <liberty@extricom.com>
>
>
