Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1EaTFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:05:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59176 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1EaTFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aXe+FWgHDahpolprPIfzkKc+k5K9fz60NmL1sUFT3iN5kmBs6+vVrWgOG67VZ/lMtR
         WJ2qhOiXKL/S4uCZ1O9YT/RY+b+P6eTXnFiT4MJ+gXaX9/w+SNUNS9Fxw8nSqL4zdzdK
         TRpaa7rU74yvlLfoKqf8EfiRsGFHwVuiEq3uw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105311138570.30137@asgard.lang.hm>
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
 <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm> <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
 <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
 <BANLkTim0pFS=Fs6ga2CV5LwOs2xxbh9svA@mail.gmail.com> <alpine.DEB.2.02.1105311122250.30137@asgard.lang.hm>
 <BANLkTi=PzyjVPCLfxa9=B6A25_vgHD3o8Q@mail.gmail.com> <alpine.DEB.2.02.1105311138570.30137@asgard.lang.hm>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Tue, 31 May 2011 21:04:59 +0200
Message-ID: <BANLkTimu2W4AXTGZsf-3QhO8YwgVMc6Riw@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: david@lang.hm
Cc: "Ted Ts'o" <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 8:54 PM,  <david@lang.hm> wrote:
> On Tue, 31 May 2011, D. Jansen wrote:
>
>> On Tue, May 31, 2011 at 8:23 PM,  <david@lang.hm> wrote:
>>>
>>> On Tue, 31 May 2011, D. Jansen wrote:
>>>
>>>> On Tue, May 31, 2011 at 4:03 AM, Ted Ts'o <tytso@mit.edu> wrote:
>>
>>>>> I can't remember the last time this has happened to me.  It's
>>>>> typically a system crash or a power loss that causes me to lose an
>>>>> OpenOffice session.
>>>>
>>>> Well, good for you! Power loss didn't ever occur to me on the other
>>>> hand, at least not on my netbook.
>>>
>>> failure to resume is effectivly power loss. a autosave to ram would be
>>> lost,
>>> just like with a power loss or system crash.
>>>
>> Well in my case only X crashes and the autosave is saved.
>
> but you have no guarantee that it would be saved without fsync.

But I would with barriers.
>
> it looks like libreoffice does 2 fsyncs per snapshot saved. This is why your
> data is saved.
>
> If this is only every 15 minutes (the default), and you have the disk
> spin-up time set to every 20 minutes, you will be spinning up the disk just
> about as frequently anyway.
>
> now if the system isn't flushing things to disk when it spins up for the
> fsync, then there is something wrong.
>
> but if it is working as designed, you get one spin-up every 15 min instead
> of one spin-up every 20 minutes, that should not be enough to kill anything.

Yes, if there was nothing else, that's probably true. But _many_
applications use fsync, even KDE's plasma shell I think.
