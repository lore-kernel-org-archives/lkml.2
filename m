Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0C2UUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:20:53 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:57653 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0C2UUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:20:52 -0400
MIME-Version: 1.0
In-Reply-To: <201003292304.39657.temerkhanov@yandex.ru>
References: <201003172118.41559.temerkhanov@cifronik.ru> <1269877373.6173.27.camel@iscandar.digidescorp.com> 
	<fa686aa41003290856t24a248a5j5dfda623ed2805c0@mail.gmail.com> 
	<201003292304.39657.temerkhanov@yandex.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 29 Mar 2010 14:20:31 -0600
X-Google-Sender-Auth: 6374b2801e37a262
Message-ID: <fa686aa41003291320o76b88ca3vd98bdef5ff592277@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Xilinx MPMC SDMA subsystem
To: Sergey Temerkhanov <temerkhanov@yandex.ru>
Cc: linuxppc-dev@lists.ozlabs.org, steve@digidescorp.com,
       microblaze-uclinux@itee.uq.edu.au,
       Sergey Temerkhanov <temerkhanov@cifronik.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 1:04 PM, Sergey Temerkhanov
<temerkhanov@yandex.ru> wrote:
> On Monday 29 March 2010 19:56:15 Grant Likely wrote:
>> On Mon, Mar 29, 2010 at 9:42 AM, Steven J. Magnani
>>
>> <steve@digidescorp.com> wrote:
>> > On Fri, 2010-03-26 at 17:53 -0600, Grant Likely wrote:
>> >> I've not got time to review this patch right now, but Sergey and
>> >> Steven, you both posted MPMC drivers on the same day; Steven on the
>> >> microblaze list and Sergey on the powerpc list. šCan you two please
>> >> coordinate and figure out how to mork toward a single driver that will
>> >> meet both your needs? šI don't want to have 2 drivers (3 if you count
>> >> the ll_temac driver) in mainline for the same hardware interface.
>> >
>> > I don't think we'll end up with a single driver. A MPMC DMA Engine
>> > driver is useful only on "loopback" SDMA ports. Sergey's code looks like
>> > a nice generic interface to Xilinx SDMA HW that could be used by the
>> > xlldma and ll_temac drivers, for instance. Both of those will get
>> > smaller, but won't go away.
>
> Yes, it's like having IBM EMAC driver and MAL layer or something
>
>> >
>> > For this to be useful to me, it would need to be located somewhere more
>> > accessible than arch/powerpc and it would need to have initialization
>> > methods that don't depend on OF. In my build I would have platform code
>> > that binds to the xlldma platform attachment, which would call Sergey's
>> > SDMA code to assign it the proper resources.
>>
>> That should be fine.
>
> Well, I'll look at my old code for the platform interface bindings. I remember
> it worked well on arch/ppc with my other drivers.

Don't get too caught up in this aspect.  of_platform_bus_type is being
merged with platform_bus_type.  One driver can be written to handle
both use cases.  However, it may not make any sense for the DMA
library layer to have a bus binding since it is mostly a set of shared
routines.  I'm fine if the bindings are only at the SDMA driver and
ll_temac driver level.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
