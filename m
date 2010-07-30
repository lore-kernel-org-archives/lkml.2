Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0G3IBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:01:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53500 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0G3IBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimFov0uUkrWR-MsgETZ9=oHfByHu2q+JOFF5qAS@mail.gmail.com>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 
	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 
	<4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> 
	<20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> 
	<20100730073704.GH1981@nb.net.home> <AANLkTimFov0uUkrWR-MsgETZ9=oHfByHu2q+JOFF5qAS@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 30 Jul 2010 10:01:28 +0200
Message-ID: <AANLkTi=anz24S=TpBGZRvrEoTKm21kWFRypD+R96T4Oz@mail.gmail.com>
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
To: Karel Zak <kzak@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 09:43, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Fri, Jul 30, 2010 at 09:37, Karel Zak <kzak@redhat.com> wrote:
>> On Thu, Jul 29, 2010 at 06:07:31PM +0200, Kay Sievers wrote:
>>> Sure it does. Sysfs attributes need to be created _before_ uevents are
>>> sent out. The current behavior is that all blockdev attributes are
>>> safely created before the event is sent.
>>
>>  Hmm... I see that in add_disk(), the "queue" subdirectory is created
>>  after disk registration (the register_disk() calls kobject_uevent()).
>>  Is it true?
>
> Might be. Then seems nobody has tried using this stuff from udev. :)
>
> blk_register_queue() probably needs to move to register_disk(), where
> the uevent is delayed until all stuff is properly created.

Seems, someone should finally move register_disk() from
fs/partition/check.c to block/genhd.c, where it belongs, and merge the
code into add_disk(), where the control over the event timing is
easily possible.

Kay
