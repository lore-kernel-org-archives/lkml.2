Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2JCV64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:58:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49545 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2JCV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk> <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com> <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 3 Oct 2012 18:58:32 -0300
Message-ID: <CAKi4VAJgRr0JkuCbMW1vEgEbr5OUiJ-zHTHtAWTbOYFcsfFodg@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 5:39 PM, Linus Torvalds
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

This would break non-udev users with different paths. Namely Android,
which uses /system/etc/firmware and /system/vendor/firmware (not sure
about them though, I'm not keen on Android camp)

So maintaining the fallback or adding a configurable entry to set the
firmware paths might be good.


Lucas De Marchi
