Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1BUOAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:00:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50437 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1BUOAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nVBssJNCoo3XO65trOnB/m0IXXFZ+N94pn82MRl8w9UblOknDnb7RcRR3BqNHnRgR/
         5qAE5RlThtdy4tjD2SyhxzfhPFo7LXT2tpuvtV5dkco3XAiXdjAoBBayjYIkO5gl/LqE
         CEhsr4I7Uf0WaaNNgyWa6i1tOLqRaHti6o99U=
MIME-Version: 1.0
In-Reply-To: <4D622243.8030507@metafoo.de>
References: <1297539554-13957-8-git-send-email-lars@metafoo.de>
	<1297652493-7207-1-git-send-email-lars@metafoo.de>
	<AANLkTimn2JYtUSUrJBQKzXrw+URD5n0Y2h7QMaFzKFdY@mail.gmail.com>
	<4D59A93A.7090800@metafoo.de>
	<AANLkTi=RJfYEoiCPgesmZUoeOy+MehZQWeWDCWoW7vnh@mail.gmail.com>
	<AANLkTik6df6X2Jw8m6SYCFi9aN2LZc=C72WCw=gDevOr@mail.gmail.com>
	<4D622243.8030507@metafoo.de>
Date: Mon, 21 Feb 2011 16:00:06 +0200
Message-ID: <AANLkTinB8i+UK2gb88Fy0zf8EO0nYksTOmZVfDOWRRro@mail.gmail.com>
Subject: Re: [PATCH 07/14 v3] bq27x00: Cache battery registers
From: Grazvydas Ignotas <notasas@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've added the patch to my bq27x00-for-upstream tree.

Thanks.

>>
>> However there is bigger problem, compiling as module and doing
>> insmod/rmmod/insmod causes kernel OOPS:
>>
>> [  882.575714] BUG: sleeping function called from invalid context at
>> arch/arm/mm/fault.c:295
>> [  882.584350] in_atomic(): 0, irqs_disabled(): 128, pid: 1154, name: insmod
>> ...
>> [  882.959930] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>> [  882.968444] pgd = c14c8000
>> [  882.977905] Internal error: Oops: 817 [#1]
>> ...
>> [  883.304412] [<c007eed8>] (__queue_work+0x140/0x260) from
>> [<c007f044>] (queue_work_on+0x2c/0x34)
>> [  883.313568] [<c007f044>] (queue_work_on+0x2c/0x34) from
>> [<bf008390>] (bq27x00_update+0x1f8/0x220 [bq27x00_battery])
>> [  883.324584] [<bf008390>] (bq27x00_update+0x1f8/0x220
>> [bq27x00_battery]) from [<bf0084c8>] (bq27x00_battery_poll+0x14/0x48
>> [bq27x00_battery])
>>
>> full backtrace attached.
>
> I can't reproduce that OOPS. And the backtrace looks a bit strange,
> queue_work_on is not called from bq27x00_update.
> Can you send me the disassembly of your bq27x00_update?

It comes from power_supply_changed, probably omitted because
queue_work is a tail function of power_supply_changed. It's probably
something i2c specific, I could try bisecting it for you if you like,
I know it doesn't happen before this series.
