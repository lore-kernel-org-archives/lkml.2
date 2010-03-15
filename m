Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936595Ab0COTgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:36:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58961 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0COTgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:36:16 -0400
Date: Mon, 15 Mar 2010 20:36:17 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2] USB: composite: allow optional removal of __init and
 __exit tags
In-reply-to: <20100315180615.GC3857@gandalf>
To: me@felipebalbi.com
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.u9mjercl7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <94ae17705a23aec612042afcc34c44f993088eca.1268307147.git.mina86@mina86.com>
 <1865d3ee9a5ca4e41844577fff9e01e63427ed71.1268656947.git.mina86@mina86.com>
 <20100315180615.GC3857@gandalf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 15, 2010 at 01:48:18PM +0100, Michal Nazarewicz wrote:
>> The composite framework has been written using __init and __exit tags
>> to mark init and exit functions as such.  This works with most of the
>> composite gadgets however some may need to call init/exit functions
>> during normal operations.  One example is mass storage gadget which
>> needs to call exit functions.
>>
>> This patch allows gadgets to define USB_NO_INIT_SEGMENT or
>> USB_NO_EXIT_SEGMENT to remove the __init and __exit declarations
>> from composite framework.

On Mon, 15 Mar 2010 19:06:15 +0100, Felipe Balbi <me@felipebalbi.com> wrote:
> wouldn't it be the same as changing from __init to __devinit and __exit
> to __devexit ??

Most of existing composite gadgets work fine with __init/__exit and I
didn't want to change their behaviour therefore changing it simply to
__devinit/__devexit would in most cases cancel the micro-optimisation
that __init/__exit bring.

Besides, I think that changing it to __devinit/__devexit won't solve
the problem that my patch is solving.  If I'm not mistaken USB gadget
and thus USB composite gadget can be registered/unregistered at any
time without support for hotplug (which, if my understanding is
correct, is the only situation when __devinit/__devexit matters) and
so on systems w/o hotplug still init and exit functions won't be
available while the module is loaded.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
