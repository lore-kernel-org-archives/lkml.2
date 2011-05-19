Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab1ESQXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:23:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52940 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESQXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FYd+KF4jgvmXpa6vIcev4MQI0BPkn5wPmD46f9nVLxYvKnT8IQyH7R5llTzuoCrjoS
         n1kcYjUHw7TMMfwMfJhJmjzTYQREwcedAw2EgcM+3JXcpVC6L5lSmIeOmu94s5jYvOSZ
         AEJU7DCvLNh3Hd5cFXYO4JDs+0S5MhlGn1+9M=
MIME-Version: 1.0
In-Reply-To: <20110518135823.a809f829.sfr@canb.auug.org.au>
References: <20110518114912.dfdf8835.sfr@canb.auug.org.au>
	<1305684362.2856.349.camel@haakon2.linux-iscsi.org>
	<20110518135823.a809f829.sfr@canb.auug.org.au>
Date: Thu, 19 May 2011 18:22:59 +0200
X-Google-Sender-Auth: IL0BNeHEotis9oQLQHY9Lv9g-dw
Message-ID: <BANLkTim7ZPr5xazm3R+DzXufaH03Zzur1Q@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the scsi tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kiran Patil <kiran.patil@intel.com>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Yi Zou <yi.zou@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4JGNCuX010456

On Wed, May 18, 2011 at 05:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> --- a/drivers/target/tcm_fc/tfc_io.c
>> +++ b/drivers/target/tcm_fc/tfc_io.c
>> @@ -206,7 +206,8 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
>> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  "xid <0x%x>, remaining <0x%x>, "
>> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  "lso_max <0x%x>\n",
>> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  __func__, fp, ep->xid,
>> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  remaining, lport->lso_max);
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  (unsigned int)remaining,
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  lport->lso_max);
>
> Given that "remaining" really is a length, surely it makes more sense to

Exactly my comments ...

> print it with %zd than to cast it and print it with %x ...

... except that size_t is unsigned, so %zu would be a little bit better.

Gr{oetje,eeting}s,

Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â Â  Â Â  -- Linus Torvalds
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
