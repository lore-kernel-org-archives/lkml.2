Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0EUKNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:13:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44561 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0EUKNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:13:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 21 May 2010 12:13:32 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 7/8] USB: gadget: g_multi: more configurable
In-reply-to: <249011.66068.qm@web180307.mail.gq1.yahoo.com>
To: David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vc1v0uw47p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <249011.66068.qm@web180307.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Added Kconfig options for each
>> function used by g_multi so that
>> one can customize the gadget to a greater extend.
>>
>> Note that it will be wise to change vendor and product ID

On Thu, 20 May 2010 18:22:54 +0200, David Brownell <david-b@pacbell.net> wrote:
> For the record .... I would *MUCH* rather see new gadgets than
> pursue this path of tweaking/customizing existing ones and thus
> removing/changing behaviors folk may rely on.

The problem with this approach is that if you have 4 USB functions you
can came up with 16 different gadgets (and that does not take into
consideration order of functions but lets ignore that).

A fully customizable gadget may let one tweak it and when he finally
settles for a set of functions develop a custom gadget (for instance by
hacking off parts of the g_multi).

I don't really expect g_multi will be widely used in its base form.  Most likely,
it will be hacked and slashed for one's needs so why not make it simple to do?

> Tweaking is OK during certain development stages, but when it comes
> to production, there should be a single version of the gadget driver
> which isn't especially dependant on Kconfig options.  It should act the
> same at all times.

On Thu, 20 May 2010 18:30:47 +0200, David Brownell <david-b@pacbell.net> wrote:
> Note that g_multi was intended to be a a fairly simple example,
> so another reason I don't like seeing all those config options
> is that it would no longer be a simple example ....

To be honest it was never my intend. :)  As a matter of fact, I'm
working on other features to add to g_multi, most notably at the
moment an "Install Mode" or "NoCD" mode.

In the end, I'd like to turn g_multi into a full flagged run-time
customizable composite gadget similar to Android's composite (except
better ;) ) so that one would be able to build her own composite
gadget in a matter of seconds without the need of calling all the
setup, cleanup, bind, etc. functions herself.

> I see you did a bunch of good work on MS-Windows interop (yay!),
> but that can be done without complexifying this driver.  Let some
> other (new) driver take that role of "complex example"), but keep
> the simple one so there's an easy approach to the easy concepts.

All in all, if I understand your point correctly, you have only
issue with the 7th patch which introduces Kconfig options.  All the
other patches seem OK, or do you have some comments on those as well?

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
