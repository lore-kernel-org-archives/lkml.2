Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab1D0NTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:19:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187Ab1D0NTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TFECFRrubWjczQTBFLVxGHzUOBw8B/WgsEq25EY1/BEIgtnoOrfej60CwaOHZ0/Z4B
         5QCW62VnVM+IlbUnJaGrbwL0Sf87+/DnYs22mWMd5Pc5o2RfiNkVNYcHYV7e46YNw0ul
         LM24j4daD9ifZjHJmbzf02NiFoHr08IW/hKcU=
MIME-Version: 1.0
In-Reply-To: <Pine.BSM.4.64L.1104261049350.4851@herc.mirbsd.org>
References: <1303317178.2587.30.camel@mulgrave.site>
	<alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
	<20110421220351.9180.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1104211500170.5741@router.home>
	<alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com>
	<4DB3840F.3060503@gmail.com>
	<alpine.DEB.2.00.1104251355410.31884@chino.kir.corp.google.com>
	<4DB63349.3070808@gmail.com>
	<Pine.BSM.4.64L.1104261049350.4851@herc.mirbsd.org>
Date: Wed, 27 Apr 2011 15:19:37 +0200
X-Google-Sender-Auth: CjOYC0TyxNWb6s44vS-LFORDg_M
Message-ID: <BANLkTin3BmJpuzUyBWV1B38oVMDbXe=fbw@mail.gmail.com>
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thorsten Glaser <tg@mirbsd.de>
Cc: Michael Schmitz <schmitzmic@googlemail.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:50, Thorsten Glaser <tg@mirbsd.de> wrote:
> Michael Schmitz dixit:
>
>>       be done unconditionally since information about present memory has not
>> yet
>>       been recorded.
>>                    If N_NORMAL_MEMORY is not accurate, slub may encounter
>> errors since it
>
> Hrm…
>
>> @@ -300,6 +300,8 @@ void __init paging_init(void)
>>               zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
>>               free_area_init_node(i, zones_size,
>>                                   m68k_memory[i].addr >> PAGE_SHIFT, NULL);
>> +                if (node_present_pages(i))
>> +                        node_set_state(i, N_NORMAL_MEMORY);
>>       }
>> }
>
> No, this has whitespace problems (tabs are expanded to spaces).

Fixed those up, applied, and will send to Linus for 2.6.39-final.

BTW, if I enable CONFIG_SLUB on my ARAnyM setup, I don't get a crash, but it
hangs after:

| INIT: version 2.86 booting

With Michael's patch, it continues fine.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
