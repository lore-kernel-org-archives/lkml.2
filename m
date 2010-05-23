Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0EWIuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:50:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53407 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0EWIuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UOTeYhLKZB7tTFEEBEvin0EaaiEYhdYYxKk05UNItIDX2Jv2FHuQpma+8FHUjwFZqT
         D5Usq1qZ4i9M4B0tvlY9q3gW4Zi0S2ip1Y90EgjrxzE02p16Ouh4DNHAv4ne70oK84UA
         5W2gbQ9Vj2Z1dHxQY0v35NT0TtWYruhDi9yvE=
MIME-Version: 1.0
In-Reply-To: <4BF8EA83.4030406@mvista.com>
References: <1274582948-11499-1-git-send-email-vapier@gentoo.org> 
	<4BF8EA83.4030406@mvista.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 23 May 2010 04:49:52 -0400
Message-ID: <AANLkTimnCOwvaHGa9FGXXPGp0_wi0KNRHIhm85fHlskD@mail.gmail.com>
Subject: Re: [PATCH] USB: musb: fix Blackfin building after power updates
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Ian Jeffray <ian@jeffray.co.uk>, linux-usb@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>, Cliff Cai <cliff.cai@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org, stable@kernel.org,
       stable-review@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 04:42, Sergei Shtylyov wrote:
> Mike Frysinger wrote:
>> The new MUSB power code needs musb_read_txhubport() to return a value (so
>> stub it as 0 like the other Blackfin hub funcs).  It also needs new helper
>> functions for saving/restoring context,
>
>   No, it doesn't. It was an erratic patch that caused these functions to be
> needed outside OMAPs. I've already submitted a patch fixing this, see:
>
> http://marc.info/?l=linux-usb&m=127427834925805

thanks ... i'll grab whatever gets merged and repost on top of that.

>> so change the apparently unused
>> musb_platform_{suspend,resume} to musb_platform_{save,restore}_context in
>> the Blackfin code.
>
>   I don't see where you're "changing" them -- and no wonder as I have
> deleted these two unused functions.

the patch was against 2.6.34, but when updating to latest git, the
related changes were dropped.  but git automerging doesnt fix
changelogs for you :p.
>>  -static inline void  musb_read_txhubport(void __iomem *mbase, u8 epnum)
>> +static inline u8 musb_read_txhubport(void __iomem *mbase, u8 epnum)
>>  {
>> +       return 0;
>>  }
>>  #endif /* CONFIG_BLACKFIN */
>
>   Besides, this actually should have been two patches...

it was addressing the same issue: new power code breaks on Blackfin systems
-mike
