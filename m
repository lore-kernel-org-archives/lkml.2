Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0LOIR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:17:58 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:44744 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0LOIR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:17:57 -0500
MIME-Version: 1.0
In-Reply-To: <20101215073920.GU19897@game.jcrosoft.org>
References: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
 <20101214161130.GB1857@suse.de> <20101215012511.GQ19897@game.jcrosoft.org>
 <20101215034713.GB3297@suse.de> <20101215073920.GU19897@game.jcrosoft.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 15 Dec 2010 09:17:39 +0100
Message-ID: <AANLkTi=PFqpC64Qm9=Z_6HkuLJ_DsxzAHmO45J+SV508@mail.gmail.com>
Subject: Re: [PATCH] base: add sysfs socs info
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 08:39, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
>> > >
>> > > Also, isn't this information already in /proc/cpu/ today?
>> > no all this information are not present in /proc/cpu and a cpu is not a soc
>> >
>> > basicaly on a board you will have one soc but some boards have more as example
>> > some ST boards you have two sh4 soc or on some amcc you have two powerpc soc
>> >
>> > with these information you are allow to dynamise the userspace based on the
>> > soc or the companion soc and also be able to display this information in a UI
>>
>> Ok, but then why not make it "real" devices and not sysdev?  We are
>> trying to fix the sysdev code to be semi-real devices, so you might as
>> well make them real ones now.
> ok I base my work on drivers/base/cpu.c
>
> where we also use sysdev
>
> can we point me a code how you want I implement it

Sysdevs devices in general are really broken concept. They duplicate
all the usual class/bus/subsystem logic in some stupid custom way,
which does not fit into the rest of the driver model. They have a have
broken event handling, so that  udev/libudev can not even "see" them
properly.

Create your own bus "soc", and register a device "id" there which has
these attributes in a group, which is assigned to the device before it
is registered.

Or maybe (really no idea ow how that fits) use the "dmi" class's
device "id", if that fits, or create a "soc" device in the "dmi" class
that has all these attributes.

Kay
