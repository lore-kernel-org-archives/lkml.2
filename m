Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0DCQf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 12:35:29 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45232 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0DCQfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 12:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <1270310756.12516.308.camel@localhost>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org> <ac3eb2511003301153i43a60720hb015071e2c992199@mail.gmail.com> 
	<m14ojxh0mz.fsf@fess.ebiederm.org> <s2hac3eb2511003302251rcbae8767ne21e9daf1546c849@mail.gmail.com> 
	<1270256303.12516.234.camel@localhost> <h2gac3eb2511004030135q2a2f5002z912974c1d2ab8853@mail.gmail.com> 
	<1270310756.12516.308.camel@localhost>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 3 Apr 2010 18:35:03 +0200
Message-ID: <x2xac3eb2511004030935z7737c424p538e17eceb6c6af4@mail.gmail.com>
Subject: Re: [PATCH 0/6] tagged sysfs support
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 3, 2010 at 18:05, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Sat, 2010-04-03 at 10:35 +0200, Kay Sievers wrote:
>> On Sat, Apr 3, 2010 at 02:58, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > On Wed, 2010-03-31 at 07:51 +0200, Kay Sievers wrote:
>> >> Yeah, /sys/bus/, which is the only sane layout of the needlessly
>> >> different 3 versions of the same thing (bus, class, block).
>> > [...]
>> >
>> > block vs class/block is arguable,
>>
>> That's already done long ago.
>>
>> > but as for abstracting the difference
>> > between bus and class... why?
>>
>> There is absolutely no need to needlessly export two versions of the
>> same thing. These directories serve no other purpose than to collect
>> all devices of the same subsystem. There is no useful information that
>> belongs to the type class or bus, they are both the same. Like
>> "inputX" is implemented as a class, but is much more like a bus.
>
> Really, how do you enumerate 'input' buses?

The current inputX devices, unlike eventX and mouseX, are like "bus devices".

>> And "usb" are devices, which are more a class of devices, and the
>> interfaces and contollers belong to a bus.
>
> What common higher-level functionality do USB devices provide?

A device file per example, which can do anything to the device. :)

>> There is really no point to make userspace needlessly complicated to
>> distinguish the both.
>>
>> We also have already a buch of subsystems which moved from class to
>> bus because they needed to express hierarchy between the same devices.
>> So the goal is to have only one type of subsystem to solve these
>> problems.
>
> That's interesting.  Which were those?

i2c, iio, and a few which have been out-of-tree and got changed before
the merge, because we knew they would not work as class devices, cause
of the need to have childs, or the need to add additional properties
at the subsystem directory level, just like pci, which has a "slots"
directory at the pci subsystem directory, such stuff is not possible
with the too simple class layout.

> [...]
>> > So while buses and classes both define device interfaces, they are
>> > fundamentally different types of interface.
>>
>> No, they are not. They are just "devices". There is no useful
>> difference these two different types expose. And the class layout is
>> fundamentally broken, and not extendable. Peole mix lists of devices
>> with custom subsystem-wide attributes, which we need to stop from
>> doing this. The bus layout can carry custom directories, which is why
>> we want that by default for all "classifications".
> [...]
>
> I understand that you want to clean up a mess, but how do you know
> you're not going to break user-space that depends on some of this mess?

Just like /sys/block is doing it, /sys/class, /sys/bus will stay as
symlinks, and not go away.

Kay
