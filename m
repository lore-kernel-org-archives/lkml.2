Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1A0BBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:01:16 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:12617 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754126Ab1A0BBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:01:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABNTQE1Ld/sX/2dsb2JhbAAMhAbNM5BqgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,383,1291611600"; 
   d="scan'208";a="89368653"
Message-ID: <4D40C3D7.90608@teksavvy.com>
Date: Wed, 26 Jan 2011 20:01:11 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com>
In-Reply-To: <4D403855.4050706@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 10:05 AM, Mark Lord wrote:
> On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
..
>> I wonder if the patch below is all that is needed...
>
> Nope. Does not work here:
>
> $ lsinput
> protocol version mismatch (expected 65536, got 65537)
>

Heh.. I just noticed something *new* in the bootlogs on my system:

kernel: Registered IR keymap rc-rc5-tv
udevd-event[6438]: run_program: '/usr/bin/ir-keytable' abnormal exit
kernel: input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input7
kernel: ir-keytable[6439]: segfault at 8 ip 00000000004012d2 sp 00007fff6d43ca60
error 4 in ir-keytable[400000+7000]
kernel: rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c
driver #0]

That's udev invoking ir-keyboard when the ir-kbd-i2c kernel module is loaded,
and that is also ir-keyboard (userspace) segfaulting when run.

That behaviour is new, with the proposed "fix" patch from this thread.
So the "fix" itself appears to also break userspace.

The ir-keyboard program reports: IR keytable control version 0.8.2

Cheers
