Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0G2OXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:23:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44423 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab0G2OXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <4C518AC9.4040208@redhat.com>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 
	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 
	<4C518AC9.4040208@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 29 Jul 2010 16:22:50 +0200
Message-ID: <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com>
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
To: Milan Broz <mbroz@redhat.com>
Cc: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org,
        kzak@redhat.com, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 16:06, Milan Broz <mbroz@redhat.com> wrote:
> On 07/29/2010 03:47 PM, Kay Sievers wrote:
>> On Thu, Jul 29, 2010 at 15:33, Milan Broz <mbroz@redhat.com> wrote:
>>> Create /sys/block/loopX/loop directory and provide these attributes:
>>>  - backing_file
>>>  - autoclear
>>>  - offset
>>>  - sizelimit
>>>
>>> To be used in util-linux-ng (and possibly elsewhere like udev rules)
>>> where code need to get loop attributes from kernel (and not store
>>> duplicate info in userspace).
>>
>> Isn't it that the loop attributes are created _after_ the loopdev is
>> registered? That would make it hard to use these attributes from udev,
>> as the event is already running while they are created.
>
> First 8 loop devices are registered always (without backing file),
> so you have wait for change event initiated from fd set ioctl anyway...
> (backing file attribute is empty in that case)

Ah, so we are sure, we always get a 'change' event, and before that,
none of these values are ever useful to read? I mean, there will not
be attributes that are interesting during an 'add' event?

Kay
