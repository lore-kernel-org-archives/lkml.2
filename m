Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0EZN3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:29:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57645 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0EZN3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OquLHKr9/WUwdmrXvs/1AmLt2F4et/J2fdWYCdThlA5RcOANoOoee1yrqWAboGfQkc
         B0W9ltcWcjbNScN3sS0nRTjus8EApzbRoyeMb9iWHCzLO72Xd2GRtmdHjlOtAv7dRXNp
         u6mmG50PCI7mIQNuf/oFBY7tcc91vqCGBRyoM=
Message-ID: <4BFD2242.4050409@gmail.com>
Date: Wed, 26 May 2010 06:29:38 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Subject: Re: PCMCIA regression
References: <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com> <4BFCCA52.3010102@gmail.com> <Pine.LNX.4.64.1005260726130.28795@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1005260726130.28795@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 04:27 AM, Mikulas Patocka wrote:
>
> On Wed, 26 May 2010, Justin P. Mattock wrote:
>
>    
>> On 05/25/2010 01:25 PM, Mikulas Patocka wrote:
>>      
>>> Hi
>>>
>>> The commit a8408c17d0038b76a83affb1b56dc18fa1e7ed86 in Linux 2.6.34-rc6
>>> broke pcmcia for me. I use 3c574 network card in yenta socket on Armada
>>> 7400 laptop. My distribution is Debian lenny.
>>>
>>> Reverting the test for "s->functions" in pccard_validate_cis makes the
>>> network card work again.
>>>
>>> Mikulas
>>>
>>> May 20 14:17:21 gerlinda vmunix: ------------[ cut here ]------------
>>> May 20 14:17:21 gerlinda vmunix: WARNING: at drivers/pcmcia/cistpl.c:1488
>>> pccard_validate_cis+0x287/0x2d0 [pcmcia]()
>>> May 20 14:17:21 gerlinda vmunix: Modules linked in: 3c574_cs ohci_hcd
>>> pcmcia rtc_cmos crc32 ide_cd_mod rtc_core usbcore rtc_lib yenta_socket
>>> cdrom psmouse pcspkr rsrc_nonstatic nls_base pcmcia_core unix
>>> May 20 14:17:21 gerlinda vmunix: Pid: 1486, comm: pccardd Not tainted
>>> 2.6.34-fast #15
>>> May 20 14:17:21 gerlinda vmunix: Call Trace:
>>> May 20 14:17:21 gerlinda vmunix:  [<cc95cc57>] ?
>>> pccard_validate_cis+0x287/0x2d0 [pcmcia]
>>> May 20 14:17:21 gerlinda vmunix:  [<cc95cc57>] ?
>>> pccard_validate_cis+0x287/0x2d0 [pcmcia]
>>> May 20 14:17:21 gerlinda vmunix:  [<c10207d6>] ?
>>> warn_slowpath_common+0x76/0xd0 May 20 14:17:21 gerlinda vmunix:
>>> [<cc95cc57>] ? pccard_validate_cis+0x287/0x2d0 [pcmcia]
>>> May 20 14:17:21 gerlinda vmunix:  [<c1020843>] ?
>>> warn_slowpath_null+0x13/0x20
>>> May 20 14:17:21 gerlinda vmunix:  [<cc95cc57>] ?
>>> pccard_validate_cis+0x287/0x2d0 [pcmcia]
>>> May 20 14:17:21 gerlinda vmunix:  [<cc83517a>] ?
>>> pcmcia_nonstatic_validate_mem+0xda/0x180 [rsrc_nonstatic]
>>> May 20 14:17:21 gerlinda vmunix:  [<c10ce0af>] ?
>>> sysfs_addrm_finish+0x7f/0xb0
>>> May 20 14:17:21 gerlinda vmunix:  [<cc9587c2>] ? pcmcia_card_add+0x72/0xf0
>>> [pcmcia]
>>> May 20 14:17:21 gerlinda vmunix:  [<c10f39e0>] ? kobject_release+0x0/0xa0
>>> May 20 14:17:21 gerlinda vmunix:  [<c10f44c9>] ? kref_put+0x29/0x60
>>> May 20 14:17:21 gerlinda vmunix:  [<cc9577cc>] ?
>>> pcmcia_card_remove+0x8c/0xa0 [pcmcia]
>>> May 20 14:17:21 gerlinda vmunix:  [<cc958a24>] ? pcmcia_requery+0x74/0x130
>>> [pcmcia]
>>> May 20 14:17:21 gerlinda vmunix:  [<c101af4e>] ? set_next_entity+0x2e/0x70
>>> May 20 14:17:21 gerlinda vmunix:  [<c101c500>] ?
>>> do_sched_setscheduler+0x90/0xa0May 20 14:17:21 gerlinda vmunix:
>>> [<c11c0883>] ? schedule+0x203/0x3c0
>>> May 20 14:17:21 gerlinda vmunix:  [<cc818109>] ? pccardd+0x219/0x470
>>> [pcmcia_core]
>>> May 20 14:17:21 gerlinda vmunix:  [<c11c095a>] ? schedule+0x2da/0x3c0
>>> May 20 14:17:21 gerlinda vmunix:  [<cc817ef0>] ? pccardd+0x0/0x470
>>> [pcmcia_core]May 20 14:17:21 gerlinda vmunix:  [<c1035124>] ?
>>> kthread+0x74/0x80
>>> May 20 14:17:21 gerlinda vmunix:  [<c10350b0>] ? kthread+0x0/0x80
>>> May 20 14:17:21 gerlinda vmunix:  [<c10030f6>] ?
>>> kernel_thread_helper+0x6/0x10
>>> May 20 14:17:21 gerlinda vmunix: ---[ end trace 256ec3e16d1d0f46 ]---
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>        
>> maybe this is similar:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=16015
>>
>> Justin P. Mattock
>>      
> No, it's different. The bug that I have is a code logic error, the
> function pccard_validate_cis is called when it shouldn't be.
>
> Mikulas
>
>    

ahh!! I see.

Justin P. Mattock
