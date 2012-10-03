Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2JCVEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:04:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57842 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab2JCVEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk> <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com> <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 3 Oct 2012 23:04:00 +0200
Message-ID: <CAPXgP13DaCK7LxfSxhB-TTe6=fkN4UjQC=Zynm30gqycJOyMpg@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 10:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 3, 2012 at 12:50 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>
>>> Ok, like this?
>>
>> This looks good to me.  Having udev do firmware loading and tieing it to
>> the driver model may have not been such a good idea so many years ago.
>> Doing it this way makes more sense.
>
> Ok, I wish this had been getting more testing in Linux-next or
> something, but I suspect that what I'll do is to commit this patch
> asap, and then commit another patch that turns off udev firmware
> loading entirely for the synchronous firmware loading case.
>
> Why? Just to get more testing, and seeing if there are reports of
> breakage. Maybe some udev out there has a different search path (or
> because udev runs in a different filesystem namespace or whatever), in
> which case running udev as a fallback would otherwise hide the fact
> that he direct kernel firmware loading isn't working.

> Ok? Comments?

The current udev directory search order is:
  /lib/firmware/updates/$(uname -r)/
  /lib/firmware/updates/
  /lib/firmware/$(uname -r)/
  /lib/firmware/

There is no commonly known /firmware directory.

http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-firmware.c#n100
http://cgit.freedesktop.org/systemd/systemd/tree/configure.ac#n548

Kay
