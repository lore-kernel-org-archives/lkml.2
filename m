Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1HRRQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:16:41 -0400
Received: from lucidpixels.com ([72.73.18.11]:50728 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1HRRQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:16:40 -0400
Date: Thu, 18 Aug 2011 13:16:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jeff Layton <jlayton@samba.org>
cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
In-Reply-To: <20110818130408.71c55b96@barsoom.rdu.redhat.com>
Message-ID: <alpine.DEB.2.02.1108181314310.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
 <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan> <20110818091140.385a9455@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan> <20110818130408.71c55b96@barsoom.rdu.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Aug 2011, Jeff Layton wrote:

> On Thu, 18 Aug 2011 09:15:36 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>>
>>
>> On Thu, 18 Aug 2011, Jeff Layton wrote:
>>
>>> On Thu, 18 Aug 2011 08:22:44 -0400 (EDT)
>>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>
>>>> Justin.
>>>>
>>>
>>> To be clear -- incoming in this case is reads or writes?
>> Reading from the CIFS share (Windows 7).
>>
>>>
>>> Up until 3.0 cifs.ko didn't parallelize writes from a single thread. In
>>> 3.0 I added a patchset to increase the allowable wsize and to allow the
>>> kernel to issue writes in parallel.
>> Ahh, good to know, have not tried writes yet.
>>
>>>
>>> Reads still suffer from the same problem however. I'm working on a
>>> patchset that should do the same thing for them, but it requires a
>>> fairly substantial overhaul of the receive codepaths.
>> Ok, that explains it then, thanks.


Hi,

Watching the rsync, it ran for a while, then:

rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": Cannot allocate memory (12)
rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_1.JPG": Cannot allocate memory (12)
rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_2.JPG": Cannot allocate memory (12)
rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": Cannot allocate memory (12)

Justin.

