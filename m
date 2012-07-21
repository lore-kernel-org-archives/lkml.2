Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2GUQYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:24:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:32888 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2GUQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120721161523.GB22896@kroah.com>
References: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
	<20120721040816.GA7313@kroah.com>
	<1342856010.21788.47.camel@ted>
	<CAMbhsRREVcqf+pnamY62wGcd2mBif8W8_CRXdJQCQvL14Dy3Eg@mail.gmail.com>
	<1342869707.21788.50.camel@ted>
	<CAMbhsRQ2EPEW+=0bhE6N9-dr44H8G_gzQ7h5LqOp7Lntr2RhTg@mail.gmail.com>
	<20120721160855.GB7565@khazad-dum.debian.net>
	<20120721161523.GB22896@kroah.com>
Date: Sat, 21 Jul 2012 09:23:58 -0700
X-Google-Sender-Auth: 6IS9GBXPOrZmSEU5ArR0Yuw6k3A
Message-ID: <CAMbhsRSAX3mt0nEnfOC3ydFG5WfMNihAGXDJuBWQyrS2DcKS=g@mail.gmail.com>
Subject: Re: sysfs permissions on dynamic attributes (led delay_on and delay_off)
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Bryan Wu <bryan.wu@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 9:15 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Jul 21, 2012 at 01:08:55PM -0300, Henrique de Moraes Holschuh wrote:
>> On Sat, 21 Jul 2012, Colin Cross wrote:
>> > The delay_on and delay_off files could easily override the values from
>> > the trigger.
>> >
>> > Sending a KOBJ_CHANGE uevent is not a great solution, it's still
>> > horribly racy in userspace.  This script would never work reliably:
>> > echo timer > trigger
>> > echo 1000 > delay_on
>> > echo 1000 > delay_off
>> > echo 255 > brightness
>>
>> Yes, and the proper fix is to instead use a fully async userspace based on
>> uevent callbacks.  Nasty as all hell.  Or the quick fix, which is to wait
>> for the system to settle after every sysfs operation that could create new
>> sysfs nodes.
>>
>> You could make sure that (1) no sysfs operation will return control to
>> userspace until it is complete, so you'd have all new sysfs nodes available
>> at the time the first echo returns [I believe it already works like that],
>
> Yes it does, what's the problem here?
>
>> and (2) either enhance sysfs to create nodes with the desired ownership and
>> permissions
>
> From the kernel, you can also do this today, if you know it's "safe" for
> users to read/write them.

You can set the permissions, but I don't know of any way to set the
owner.  For my case, I need them to be writable by the "system" user
but not by all users.
