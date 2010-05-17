Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0EQTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:44:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0EQTo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:44:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xU97Rx1Eoudm8sl7RZVNOlu4vagicyHwC+k+cmjVcJOtTqyGYKrNwyHopig4sYoC6
	qE0eVp4eO2FP+/pontr9g==
MIME-Version: 1.0
In-Reply-To: <yq1pr0u8igd.fsf@sermon.lab.mkp.net>
References: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
	 <yq1pr0u8igd.fsf@sermon.lab.mkp.net>
Date: Mon, 17 May 2010 12:44:24 -0700
Message-ID: <AANLkTikjfv2DHshXhxwPpyvpCvvGLiK-IOcucXJX3jBQ@mail.gmail.com>
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

On Mon, May 17, 2010 at 11:57 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Jiaying" == Jiaying Zhang <jiayingz@google.com> writes:
>
Thanks a lot for the comments!

> Jiaying,
>
> Jiaying> The currect blkdev_issue_discard() function assumes 512 sector
> Jiaying> size.
>
> All of the block layer works on 512-byte sector units.  We don't
> generally convert to logical blocks until we're in the disk driver.
>
It is true that all of the block layer works on 512-byte sector size, but
I think it is good to check for address alignment for discard request so
we don't insert unnecessary discard requests into the request queue.
There are also certain disk drivers that assume a discard request
passed from the block layer is already properly aligned. We could
argue that those disk drivers need to fix that but I think it is better
that the block layer takes care of the address alignment so individual
disk drivers don't need to check that on their own.

>
> Jiaying> We have seen some problem when using discard on a SSD that has
> Jiaying> larger sector size. The following patch adjusts the starting
> Jiaying> address and size of a discard request to be aligned with hwsect
> Jiaying> size.
>
> Jiaying> + int hwsect_shift =
> Jiaying>        blksize_bits(bdev_logical_block_size(bdev)) - 9;
>
> Let's stop using the term hardware sector size.  It's an anachronism.
Ok. I will change those terms.

>
> I guess I could understand if you aligned to the physical block size.
> But the logical doesn't make much sense to me.
>
Physical block size seems better. I will change to use that.

> What is your logical block size?  Right now we only handle 512 bytes and
> 4KB in the discard path.
>
512 bytes and 4KB seem to be the most common sizes but I wouldn't be
surprised to see other logical block size.

Jiaying
> --
> Martin K. Petersen      Oracle Linux Engineering
>
