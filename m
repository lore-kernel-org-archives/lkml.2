Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0HKI4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:56:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59567 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640Ab0HKI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:56:41 -0400
Message-ID: <4C6265BE.7090509@canonical.com>
Date: Wed, 11 Aug 2010 10:56:30 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Eric Sandeen <sandeen@redhat.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [116/165] ext4: dont return to userspace
 after freezing the fs with a mutex held
References: <20100730171510.105264205@clark.site> <4C56B45E.9010601@canonical.com> <4C56FA35.7060607@redhat.com> <20100802184806.GA16878@kroah.com> <20100807040732.GB16342@khazad-dum.debian.net> <4C5D61E7.9090008@redhat.com> <4C5FC3BB.4030602@canonical.com> <20100810201639.GC12680@kroah.com>
In-Reply-To: <20100810201639.GC12680@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 10:16 PM, Greg KH wrote:
> On Mon, Aug 09, 2010 at 11:00:43AM +0200, Stefan Bader wrote:
>> On 08/07/2010 03:38 PM, Eric Sandeen wrote:
>>> Henrique de Moraes Holschuh wrote:
>>>> On Mon, 02 Aug 2010, Greg KH wrote:
>>>>> On Mon, Aug 02, 2010 at 12:02:45PM -0500, Eric Sandeen wrote:
>>>>>> On 08/02/2010 07:04 AM, Stefan Bader wrote:
>>>>>>> We have reports about this patch breaking lvm snapshhots. Eric, there is a patch
>>>>>>> mentioned which is supposed to fix things but its not upstream, yet.
>>>>>>> Do you know what happened to that?
>>>>>> right, patch below is needed to fix things.
>>>>>>
>>>>>> Ted just acked it on the list recently; Greg, I'd either drop 116/165
>>>>>> for now, or include the patch below which should be upstream soon...
>>>>> I can't take anything that isn't upstream yet.
>>>>>
>>>>> And I just released with this patch in the kernel, should I do a revert
>>>>> and do a new release?
>>>>
>>>> Any answers on this?
>>>>
>>>
>>> Yes, I'd revert it for now, I'm afraid, if the other patch isn't upstream
>>> yet.
>>>
>>> Sorry about that,
>>>
>>> -Eric
>>
>> Upstream as of now (same SHA1 as in linux-next):
>>
>> >From 437f88cc031ffe7f37f3e705367f4fe1f4be8b0f Mon Sep 17 00:00:00 2001
>> From: Eric Sandeen <sandeen@sandeen.net>
>> Date: Sun, 1 Aug 2010 17:33:29 -0400
>> Subject: [PATCH] (pre-stable) ext4: fix freeze deadlock under IO
> 
> It looks like I can't drop the original one, as this patch builds on it.
> So I'll just queue this one up.
> 
> Should it also go into other -stable releases (like .35 and/or .34 -stable?)
> 

Final call would be Eric/Ted but as far as I can see:

.34: not for now (patch that causes regression not backported there (yet))
.35: yes (offending patch has been in 2.6.35-rc1)

-Stefan

> thanks,
> 
> greg k-h

