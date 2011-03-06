Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1CFUAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:00:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62860 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1CFUAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D4c/ztCC/GZD9v8pNfV2f1HEAZtJyt/21O5hdeYL6u41Q15iAa5gPCncEgbOx0uHQh
         PY9N82hc1KWtpgCZEzNKpaW/mgVHR8CDi1KaDLdbRunLCaZ63zLXy5Mbekeqlr3pB7pF
         9RDDjo++C/Zs/mzzRXqXN762LiBQInkKoDZ28=
MIME-Version: 1.0
In-Reply-To: <20110306111141.9cc51306.rdunlap@xenotime.net>
References: <20110306070832.GA26188@asset.uwaterloo.ca>
	<20110306111141.9cc51306.rdunlap@xenotime.net>
Date: Sun, 6 Mar 2011 21:00:13 +0100
X-Google-Sender-Auth: hWEU28Oz8psAGkpyIf0DN5p6ARw
Message-ID: <AANLkTiko+HzYMnGEtvb63Fzi2eNge6_iWPmk7EfjFma7@mail.gmail.com>
Subject: Re: [Patch] ariadne: fix possible null dereference
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: j223yang@asset.uwaterloo.ca, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 20:11, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Sun, 6 Mar 2011 02:08:32 -0500 j223yang@asset.uwaterloo.ca wrote:
>
>> Hi Randy,
>> I have tested my patch, and it is ok now.
>> Could you please try patching again? Sorry for previous trouble.
>> Thank you!
>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

>> ------------------------------------------------------
>> This patch fixes bugzilla #13853:
>> https://bugzilla.kernel.org/show_bug.cgi?id=13853
>>
>> The patch removes dereference of 'dev' after testing for NULL.
>>
>> Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
>> ---
>>  ariadne.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ariadne.c b/drivers/net/ariadne.c
>> --- a/drivers/net/ariadne.c   2011-03-04 11:16:42.332164362 -0500
>> +++ b/drivers/net/ariadne.c   2011-03-05 21:11:52.949164759 -0500
>> @@ -420,7 +420,7 @@ static inline void ariadne_reset(struct
>>  static irqreturn_t ariadne_interrupt(int irq, void *data)
>>  {
>>      struct net_device *dev = (struct net_device *)data;
>> -    volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
>> +    volatile struct Am79C960 *lance;
>>      struct ariadne_private *priv;
>>      int csr0, boguscnt;
>>      int handled = 0;
>> @@ -430,6 +430,7 @@ static irqreturn_t ariadne_interrupt(int
>>       return IRQ_NONE;
>>      }
>>
>> +    lance = (struct Am79C960 *)dev->base_addr;
>>      lance->RAP = CSR0;                       /* PCnet-ISA Controller Status */
>>
>>      if (!(lance->RDP & INTR))                /* Check if any interrupt has been */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
