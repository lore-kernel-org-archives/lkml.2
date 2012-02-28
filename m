Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2B1VAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:00:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37273 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2B1VAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120228.154914.662485432055205683.davem@davemloft.net>
References: <1330091162-8141-4-git-send-email-danny.kukawka@bisect.de>
	<CAMuHMdXAwgtwbCV_=qJnrs=YPZksoEBkjnQB=JbR7fc+UyKdzw@mail.gmail.com>
	<CAMuHMdW0Oh7h8tv85ScgHB50vMaZSU7S3cPJRsChnRe2sNL_kA@mail.gmail.com>
	<20120228.154914.662485432055205683.davem@davemloft.net>
Date: Tue, 28 Feb 2012 22:00:50 +0100
X-Google-Sender-Auth: urtqzdZipCbeYr_tqXntRBo68Rc
Message-ID: <CAMuHMdUudso1YpukfxvGdb2fAYZBJewTgQEh-aU_KB0-U2o6WQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] cirrus/mac89x0: print MAC via printk format specifier
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: danny.kukawka@bisect.de, dkukawka@suse.de, jeffrey.t.kirsher@intel.com,
        jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

2012/2/28 David Miller <davem@davemloft.net>:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Tue, 28 Feb 2012 21:45:30 +0100
>
>> drivers/net/ethernet/cirrus/mac89x0.c: In function ‘set_mac_address’:
>> drivers/net/ethernet/cirrus/mac89x0.c:597: warning: dereferencing
>> ‘void *’ pointer
>> drivers/net/ethernet/cirrus/mac89x0.c:597: error: request for member
>> ‘sa_data’ in something not a structure or union
>> drivers/net/ethernet/cirrus/mac89x0.c:600: warning: dereferencing
>> ‘void *’ pointer
>> drivers/net/ethernet/cirrus/mac89x0.c:600: error: request for member
>> ‘sa_data’ in something not a structure or union
>> drivers/net/ethernet/cirrus/mac89x0.c:595: warning: unused variable ‘saddr’
>
> Thanks, I've fixed this as follows and pushed to net-next:
>
> --------------------
> mac89x0: Fix build error.
>
> Need to use the new 'saddr' variable not the void 'addr' in
> set_mac_address().
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, that fixed the build.

What about the is_valid_ether_addr() check?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
