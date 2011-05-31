Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab1EaSy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:54:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:49325 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab1EaSy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:54:27 -0400
Date: Tue, 31 May 2011 11:54:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "D. Jansen" <d.g.jansen@googlemail.com>
cc: "Ted Ts'o" <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <BANLkTi=PzyjVPCLfxa9=B6A25_vgHD3o8Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105311138570.30137@asgard.lang.hm>
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
 <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com> <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com> <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm> <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
 <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com> <BANLkTim0pFS=Fs6ga2CV5LwOs2xxbh9svA@mail.gmail.com> <alpine.DEB.2.02.1105311122250.30137@asgard.lang.hm> <BANLkTi=PzyjVPCLfxa9=B6A25_vgHD3o8Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-260190196-1306868050=:30137"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-260190196-1306868050=:30137
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 31 May 2011, D. Jansen wrote:

> On Tue, May 31, 2011 at 8:23 PM,  <david@lang.hm> wrote:
>> On Tue, 31 May 2011, D. Jansen wrote:
>>
>>> On Tue, May 31, 2011 at 4:03 AM, Ted Ts'o <tytso@mit.edu> wrote:
>
>>>> I can't remember the last time this has happened to me.  It's
>>>> typically a system crash or a power loss that causes me to lose an
>>>> OpenOffice session.
>>>
>>> Well, good for you! Power loss didn't ever occur to me on the other
>>> hand, at least not on my netbook.
>>
>> failure to resume is effectivly power loss. a autosave to ram would be lost,
>> just like with a power loss or system crash.
>>
> Well in my case only X crashes and the autosave is saved.

but you have no guarantee that it would be saved without fsync.

it looks like libreoffice does 2 fsyncs per snapshot saved. This is why 
your data is saved.

If this is only every 15 minutes (the default), and you have the disk 
spin-up time set to every 20 minutes, you will be spinning up the disk 
just about as frequently anyway.

now if the system isn't flushing things to disk when it spins up for the 
fsync, then there is something wrong.

but if it is working as designed, you get one spin-up every 15 min instead 
of one spin-up every 20 minutes, that should not be enough to kill 
anything.

David Lang
--680960-260190196-1306868050=:30137--
