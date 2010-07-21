Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab0GUTvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:51:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8776 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab0GUTvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:51:43 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 21 Jul 2010 21:53:03 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <1279741029.31376.33.camel@c-dwalke-linux.qualcomm.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Message-id: <op.vf7lipj67p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
 <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
 <op.vf5o28st7p4s8u@pikus>
 <1279654698.26765.31.camel@c-dwalke-linux.qualcomm.com>
 <op.vf6zo9vb7p4s8u@pikus>
 <1279733750.31376.14.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7gt3qy7p4s8u@pikus>
 <1279736348.31376.20.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7h1yc47p4s8u@pikus>
 <1279738688.31376.24.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7j13067p4s8u@pikus>
 <1279741029.31376.33.camel@c-dwalke-linux.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 21:37:09 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:
> What makes you assume that the bootloader would have these strings?
> Do your devices have these strings? Maybe mine don't have them.

I don't assume.  I only state it as one of the possibilities.

> Assume the strings are gone and you can't find them, or have no idea
> what they should be. What do you do then?

Ask Google?

I have a better question for you though: assume the "mem" parameter is
lost and you have no idea what it should be?  There are many parameters
passed to kernel by bootloader and you could ask about all of them.

Passing cma configuration via command line is one of the possibilities
-- especially convenient during development -- but I would expect platform
defaults in a final product so you may well not need to worry about it.

Bottom line: if you destroyed your device, you are screwed.

>>>> Imagine a developer who needs to recompile the kernel and reflash the
>>>> device each time she wants to change the configuration...  Command line
>>>> arguments seems a better option for development.

>>> So make it a default off debug configuration option ..

>> I don't really see the point of doing that.  Adding the command line
>> parameters is really a minor cost so there will be no benefits from
>> removing it.

> Well, I like my kernel minus bloat so that's a good reason. I don't see
> a good reason to keep the interface in a production situation .. Maybe
> during development , but really I don't see even a developer needing to
> make the kind of changes your suggesting very often.

As I've said, removing the command line parameters would not benefit the
kernel that much.  It's like 1% of the code or less.  On the other hand,
it would add complexity to the CMA framework which is a good reason not
to do that.

Would you also argue about removing all the other kernel parameters as
well? I bet you don't use most of them.  Still they are there because
removing them would add too much complexity to the code (conditional
compilation, etc.).

I'm not saying that removing “bloat” (or unused options if you will)
 from the kernel is a bad thing but there is a line where costs of
doing so negate the benefits.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
