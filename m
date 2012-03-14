Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2CNBn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:43:27 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54923 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760663Ab2CNBnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxq=GWof-ExXjeC2nwUBcGi46SKwcvc2iccfymbbyXbfA@mail.gmail.com>
References: <201203032122.36745.chunkeey@googlemail.com> <201203132042.07794.rjw@sisk.pl>
 <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com>
 <201203140110.40671.rjw@sisk.pl> <CAPXgP118s+DuLaATKOq7w=F82GB=8PkwUJDichffXA-Er6Zqvw@mail.gmail.com>
 <CA+55aFxq=GWof-ExXjeC2nwUBcGi46SKwcvc2iccfymbbyXbfA@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 14 Mar 2012 02:43:05 +0100
Message-ID: <CAPXgP11ZKT-ZNBLdPQWotFayz9m7pKcNHDBPWxcp_2-ja+SAcQ@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 01:54, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 13, 2012 at 5:14 PM, Kay Sievers <kay@vrfy.org> wrote:
>>
>> Yeah it's certainly useful to disable the exec() during suspend calls,
>> much more than using the exec() inhibit flag for the firmware loader
>> to throw a warning about suspend issues.
>
> Kay, just stop confusing the issue already.
>
> It has *nothing* to do with exec. It has *nothing* to do with
> /sbin/hotplug. Stop repeating that stupid mantra. It's totally and
> utterly irrelevant.
>
> You can't load firmware while the system is suspended. End of story.
> You can't load it using /sbin/hotplug, you can't load it with dbus,
> you cannot load it FULL STOP.
>
> The filesystem you'd want to load it from may simply not be ready yet.
>
> This has nothing to do with exec or anything else. It's very simple:
> you cannot load firmware while the system isn't yet fully up.
> Seriously.
>
> You need to wait to load the firmware until everything is all done,
> and things work.
>
> Or you should - preferably - just have preloaded the damn thing.

usermodehelper_is_disabled() is a flag from kmod which is all about
exec(). That flag should not be used to decide if a firmware request
can be issued by a driver and queued up or not. There is no
usermodehelper involved at all in loading firmware today, hence we
should not use that flag.

Firmware requests are asynchronous like all other driver-core uevents
too, and they can be queued at any time. firmware is not special here.
The kernel has no real business in warning about that, or refusing a
request, just the same way it has no business to tell that other
events are queued but not directly delivered to userspace at that very
moment.

The firmware requests will travel into userspace just fine when stuff is ready.

Kay
