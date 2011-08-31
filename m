Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1HaG5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:57:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48599 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1HaG53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <CA+O4pCKteFZBT0UMetuk4-gsUf4wG3DXnOooW47GWD7o=dgpQQ@mail.gmail.com>
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
	<201108171914.52257.oliver@neukum.org>
	<CA+O4pCK3vZjZwM0D7Q0gzsTZRJC1PfzYvoVmq-g2jJQ=uP_6ug@mail.gmail.com>
	<201108190823.06638.oliver@neukum.org>
	<CA+O4pCKteFZBT0UMetuk4-gsUf4wG3DXnOooW47GWD7o=dgpQQ@mail.gmail.com>
Date: Wed, 31 Aug 2011 08:57:28 +0200
Message-ID: <CA+O4pC+gxbLaHDyAUB-ro1Z-jTGdMfey9yJht1Ux4jWhanKbkg@mail.gmail.com>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Oliver,

can you justify why 190K is acceptable for Isochronous (which has been
in the kernel for a long long time now) but less than 50k is suddenly
not acceptable for bulk when using USBFS? Especially while the wild
out there already approved that 190K is okay even on embedded systems?
That's the only thing I would like to know :-)

We made many tests here (and have many more customers using Isoc 190k
buffers) and memory allocation has a much better performance instead
of pushing ioctls forward/backward for reading those small packets.
I do understand your concern but from my point and experience with it
(we've been using it for 3 years so far) it does not cause any
problem. We reached the 1k amount of users using 190k Isoc buffers a
long time ago, those are pushing 170 Mbit a second. The bulk purpose
is for 80mbit a second only.
I would just like to have all supported modes with performance and not
too many changes. Currently we only get good performance with
isochronous, bulk USBFS performance could just be better with Linux,
our software works well enough with Mac, Solaris and FreeBSD with Bulk
and Iso.

BR,
Markus

On Fri, Aug 19, 2011 at 12:45 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Fri, Aug 19, 2011 at 8:23 AM, Oliver Neukum <oliver@neukum.org> wrote:
>> Am Mittwoch, 17. August 2011, 19:44:16 schrieb Markus Rechberger:
>>> I understand that USBFS is not 100% optimized, although we are already
>>> using 3-4 times that much buffer with isochronous and it was working
>>> fine for years so far as long as the system doesn't run out of memory
>>> .. but even kerneldrivers would have issues with it in such a
>>> situation.
>>
>> The problem is not what happens on your test system dedicated to this use.
>> There it'll work. But you allowed everybody else to make the kernel request
>> the second largest chunk of memory there is. On a otherwise busy system
>> with fragmented memory this is not good.
>>
>> As I said, you want scatter/gather if you need this.
>> There still would be the problem with the API, but if this is really a problem,
>> you could define a new ioctl()
>>
>
> let's say there are a few thousand users of the 190k isochronous implementation.
> I don't want to add more complex code to the kernel, if it's not
> accepted I'm okay with it,
> since I know the performance impact I can recommend it to those who
> are interested in it.
> Our software works without it anyway, and Bulk is just for special use
> in our case.
>
> Best Regards,
> Markus
>
