Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0KJB7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:59:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59063 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0KJB7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:59:32 -0500
MIME-Version: 1.0
In-Reply-To: <1289353544.22787.49.camel@concordia>
References: <1289339119.2191.92.camel@laptop> <20101109221338.GA19947@suse.de>
 <1289345811.10536.8.camel@concordia> <AANLkTi=UftgQn0ydRd2wszqFtpRrkEcW7dzfapKKix_V@mail.gmail.com>
 <1289350360.22787.9.camel@concordia> <AANLkTikGHNkUN6t9rPhdE6XOQiqb5xAzH_9eY6L9h2H2@mail.gmail.com>
 <1289351423.22787.22.camel@concordia> <AANLkTin_VixECn4AdQW_xC=_5ZNY5wBsif6cW5dDEJFe@mail.gmail.com>
 <1289353544.22787.49.camel@concordia>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 10 Nov 2010 02:59:16 +0100
Message-ID: <AANLkTimksMYmLZrg3RUkbvYygeu1bLXkV7b4y8JeEAih@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
To: michael@ellerman.id.au
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:45, Michael Ellerman <michael@ellerman.id.au> wrote:
> On Wed, 2010-11-10 at 02:19 +0100, Kay Sievers wrote:
>> On Wed, Nov 10, 2010 at 02:10, Michael Ellerman <michael@ellerman.id.au> wrote:
>> > On Wed, 2010-11-10 at 01:57 +0100, Kay Sievers wrote:
>> >> Stay on the list please, with any possible reply. Thanks!
>> >
>> > You dropped the CC when you replied, or is my mailer being weird?
>>
>> You replied to me only:
>>   From: Michael Ellerman <michael@ellerman.id.au>
>>   To: Kay Sievers <kay.sievers@vrfy.org>
>
> Because you replied to me only, or at least that's what I see at my end.

Sure, I don't add lists back when people reply to me only. You never
know why they do that, and if they have a reason for it. That's why I
added the the same mail:
  "Stay on the list please, with any possible reply. Thanks!"

>> Devices can never be on two subsystems at the same time. Not with
>> classes, not with buses, that was never, and probably will never be
>> possible.
>
> OK, I guess I'm getting my terminology wrong. My devices, which show up
> in /sys/class/foo are symlinks into /sys/devices/virtual/foo, so they
> _appear_ to be in two places.
>
> I also see entries for example in /sys/class/scsi_disk that link
> into /sys/devices/pci.

Sure, all devices (devices are real directories) end up in the tree in
/sys/devices/. That's one tree, where all the devices from different
subsystems stack on top of others.


All devices have a symlink called 'subsystem' which points back to the
individual class the device belongs to.

To find all device of a specific subsystem, you start at the subsystem
directory (class/bus) which collects them (only symlinks to the
device, not directories).

That way you will find a blockdev, even when it's deep down in a chain
of devices:
  pci:bridge/pci:dev/scsi:host/scsi:target/scsi:lun/block

All devices get announced to userspace only by their devpath, never by
their class or bus directory. If you wan to watch the stuff in action,
run:
  udevadm monitor --kernel
and plug in a USB stick. You see that you get all device only at one
place created, the rest (which you can't see in the event) is
symlinks, which don't matter for the device itself, only for userspace
tasks to find them.

Kay
