Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2CMX0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:26:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36072 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2CMX0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:26:18 -0400
MIME-Version: 1.0
In-Reply-To: <201203132042.07794.rjw@sisk.pl>
References: <201203032122.36745.chunkeey@googlemail.com> <20120309233659.GA21256@kroah.com>
 <CAPXgP10oHRnPo7Es1RX8GM68dH13E0rzcFhXzOYFPcmKs=yh1A@mail.gmail.com> <201203132042.07794.rjw@sisk.pl>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 14 Mar 2012 00:25:58 +0100
Message-ID: <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 20:42, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, March 11, 2012, Kay Sievers wrote:
>> On Sat, Mar 10, 2012 at 00:36, Greg KH <gregkh@linuxfoundation.org> wrote:

>> > What does uevent have to do with things here?
>>
>> I don't think that the firmware loader should care about the
>> usermodehelper at all, and that stuff fiddling should just be removed
>> from the firmware class.
>
> It's there to warn people that their drivers do stupid things like
> loading frimware during system resume, which is guaranteed not to work.
>
> IOW, it's there very much on purpose.

Using the /sbin/hotplug is no case that needs any warning. It' such a
broken model these days, that firmware loading is the least problem
that occurs with it.

>> Forking /sbin/hotplug is disabled by default, it is a broken concept,
>> and it cannot work reliably on today's systems.
>>
>> Firmware is not loaded by /sbin/hotplug since many years, but by udev
>> or whatever service handles uevents, like ueventd on android.
>
> Which I'm not sure why is relevant here.

It is relevant in the sense that the firmware loader should not even
know that a uevent *can* cause a usermodehelper exec() if it runs in
legacy mode. The firmware loader just has no business in fiddling with
the details of driver core legacy stuff. I don't think his warning
makes much sense.

Kay
