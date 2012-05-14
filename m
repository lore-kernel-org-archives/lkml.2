Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab2ENV0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:26:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2ENV0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:26:21 -0400
Message-ID: <4FB17876.5060604@suse.cz>
Date: Mon, 14 May 2012 23:26:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@pld-linux.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stale object files (was Re: Linux-3.4-rc7)
References: <CA+55aFwB-3rsrVo1vur6drZMvhSWNHAJZfEYC=WXfpwwvLfxFQ@mail.gmail.com>
In-Reply-To: <CA+55aFwB-3rsrVo1vur6drZMvhSWNHAJZfEYC=WXfpwwvLfxFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.5.2012 23:40, Linus Torvalds napsal(a):
> Ok, added the appropriate kbuild people: Machal - skb_dev_set() no
> longer exists, there are no users of it, so it looks like something
> doesn't get rebuilt correctly.
> 
> Paweł, can you please also send us the config file you're using, then
> we can recreate the exact setup you have.
> 
>                      Linus
> 
> On Sun, May 13, 2012 at 2:13 PM, Paweł Sikora <pluto@pld-linux.org> wrote:
>>
>> starting from current rc7 build tree...
>>
>> $ cp .config ../config
>> $ make distclean
>> $ git co v3.4-rc5
>> $ cp ../config .config
>> $ make oldconfig
>> $ make -j8
>> $ git co v3.4-rc7
>> $ make oldconfig
>> $ make -j8

This make results in

ERROR: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

The second failure is simply GIGO.

Michal
