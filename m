Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0ERA5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:57:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0ERA5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:57:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nW0h7Qq1a0LFYpsAXN4WNShIkvu8m2dCITAMfdLB96lMwC1vAu/wE2HvPpWxc3oMT
	DReUMIivdRgK2aWJchyqg==
MIME-Version: 1.0
In-Reply-To: <yq1pr0uxpqm.fsf@sermon.lab.mkp.net>
References: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
	 <yq1pr0u8igd.fsf@sermon.lab.mkp.net>
	 <AANLkTikjfv2DHshXhxwPpyvpCvvGLiK-IOcucXJX3jBQ@mail.gmail.com>
	 <yq1pr0uxpqm.fsf@sermon.lab.mkp.net>
Date: Mon, 17 May 2010 17:57:01 -0700
Message-ID: <AANLkTilecMRKZy1ojkbUk-9oFVzRO_aMv5p3YY2WMnIw@mail.gmail.com>
Subject: Re: [PATCH, RFC] addjust discard request to be aligned with hwsect 
	size to support SSDs with larger sector size
From: Jiaying Zhang <jiayingz@google.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hch@infradead.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       mrubin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 1:00 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Jiaying" == Jiaying Zhang <jiayingz@google.com> writes:
>
> Jiaying> It is true that all of the block layer works on 512-byte sector
> Jiaying> size, but I think it is good to check for address alignment for
> Jiaying> discard request so we don't insert unnecessary discard requests
> Jiaying> into the request queue.
>
> Well, then what happens when you stripe or use DM on devices with
> different discard granularity?  Or what about a mirror?  Or multiple
> levels of stacking of heterogeneous devices.
>
> There are good reasons why we postpone the logical block scaling until
> we're preparing the request for the actual physical device.
>
Good point.

I am now open to either changing the patch to use discard_granularity
alignment or simply dropping the patch and leave the alignment checking
for disk drivers to deal with. Either way, disk driver needs to be changed.
Please let me know if you think using discard_granularity is the right
way to go. I will post a new patch in that case.

Jiaying

>
> Jiaying> There are also certain disk drivers that assume a discard
> Jiaying> request passed from the block layer is already properly
> Jiaying> aligned. We could argue that those disk drivers need to fix
> Jiaying> that
>
> Which is what I'm arguing :)
>
>
> Jiaying> 512 bytes and 4KB seem to be the most common sizes but I
> Jiaying> wouldn't be surprised to see other logical block size.
>
> That's the reason I'm asking.  If you have a different lbs then let's by
> all means add support for it.  Or make the ULD scaling generic.
>
> I'm open to aligning to the reported discard granularity in the ULD, for
> instance.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
>
