Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1JMJkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:40:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41258 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1JMJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:39:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAHFNz9JE6FcBHyrSFEnnAjKsPtHWnYush-UMsg-tBLQfQ=Zwaw@mail.gmail.com>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
	<CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
	<20111012203337.GA14572@suse.de>
	<CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com>
	<CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<CAHFNz9JUV6wabQxsvrxPRX6q41sWNMDy8DJcOpNTecNTbL=XaQ@mail.gmail.com>
	<CA+O4pCJ2gDicdC7BbCbo0m3xdCX0cdhY-Azn9aqu6+C58u0kgQ@mail.gmail.com>
	<CAHFNz9+a4PjsAoBYF-bJ9nSOzNtEVq23UJzxSTxo=fdmSGOJPw@mail.gmail.com>
	<CA+O4pC+Qo0VVM26RZXkKs18vJ-uG-YGp1vxtKBr0nzRSOitPtA@mail.gmail.com>
	<CAHFNz9JE6FcBHyrSFEnnAjKsPtHWnYush-UMsg-tBLQfQ=Zwaw@mail.gmail.com>
Date: Thu, 13 Oct 2011 11:39:57 +0200
Message-ID: <CA+O4pC+mBw9wQp6kAiVVTc8FABGf2bCtmWLYVuJxmELdH+PGPg@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:34 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> yes the PID is 0x1fff which are null packets over there, so those ones are okay.
>> Main point is it works and it would even comply with certain HW specs (the other
>> device points out about 256*188 bulk transfer buffer sizes.
>>
>> Now it would be the time for some people to open their eyes and get
>> that patch in.
>
>
> Call me dumb, but it still defies my logic why there would be stream
> corruption with a smaller buffer size, if the driver is handling the
> stream correctly.
>

you can see it in the logfile that the TS packets don't start as they should
0x47 is not the first value which is wrong and so on. And this is a
fact which everyone
can see by looking at the logfile.
At least every second transfer would have to start with 0x47, at the
point of logging the userspace
application does not have access to the USB buffer.

> I can probably imagine that there could be a likely chance, user space
> would have to poll more often in case with smaller buffers, while
> making it larger you increase the latency of the stream; that being a
> double edged blade.
>
>
>> The maximum transfer buffer size was derived from our other device which can
>> do the flexible setting. According to the specification it is no magic value.
>
>
> So, with your single device, if you were to make changes to some
> "magical constants"; and tomorrow if someone wants to have
> modifications again, what would you do ?

please do some investigation about the patch, if the value is
increased it does not
affect any previous application. That constant is not readable from
the kernel so applications
need to hardcode it. Small buffers are totally unrelated to that.

That is what I don't like here that some people are talking without
doing their homework and reviewing
what it is about.

> If that change is a must,
> maybe it should be configurable in some way, rather than having
> another fixed magical number.
>

Although I agree with that one.

BR,
Markus
