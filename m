Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0IOBBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:01:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41464 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0IOBBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <1284511071.3551.1.camel@maxim-laptop>
References: <1284284969.2928.18.camel@maxim-laptop> <1284427621.4127.7.camel@maxim-laptop>
 <4C8F2699.3020509@kernel.org> <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
 <1284507516.4963.2.camel@maxim-laptop> <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
 <1284511071.3551.1.camel@maxim-laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 15 Sep 2010 03:01:35 +0200
Message-ID: <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 02:37, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Wed, 2010-09-15 at 01:49 +0200, Kay Sievers wrote:
>> On Wed, Sep 15, 2010 at 01:38, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> > On Tue, 2010-09-14 at 10:07 +0200, Kay Sievers wrote:
>>
>> >> Are we sure, that there is something that still polls the drive?
>> >> Udisks is only auto-started, when the desktop calls into some D-Bus
>> >> methods, unlike HAL where it was an init script.
>> >
>> > Note that on current vanilla head, I applied the attached manual revert
>> > patch, and problem disappears (and probably introduces the same bug that
>> > patch supposed to fix).
>>
>> Can you please check which process polls the device, and attach an
>> strace to it, to see what's going on?
> As far as I can tell there is no such process.
> (at least sudo fuser /dev/sr0 doesn't show up anything with or without
> cd in the drive)
>>
>> If there is no such process, does "touch /dev/sr0" create the missing event?
> Yes.

Hmm, strange, I really have no idea why the old kernel works
differently for you.

The behavior you describe for the current kernel seems correct and is
the expected one. If there is nothing in userspace that polls
periodically, than we can't expect any event for a media change.

It's only the polling that should be able to trigger these events for
the device. the device itself can't report any changes to the host,
unless you have a SATA drive which can send AN (async notification)
events. But we disabled the AN support recently, because it was
running in loops on some boxes.

Kay
