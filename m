Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2AYXKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:10:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37199 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2AYXKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de>
References: <20120124023932.023409422@clark.kroah.org>
	<1327423431-13965-1-git-send-email-pbonzini@redhat.com>
	<20120125223937.GA12516@kroah.com>
	<alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de>
Date: Wed, 25 Jan 2012 18:10:47 -0500
Message-ID: <CA+5PVA601fTyuTc66nvY_9pZPE5i5DkBkKpyL3-i=q9OxkoT+g@mail.gmail.com>
Subject: Re: [v2] Re: [091/129] block: fail SCSI passthrough ioctls on
 partition devices
From: Josh Boyer <jwboyer@gmail.com>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Greg KH <greg@kroah.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 5:51 PM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
> On Wed, 25 Jan 2012, Greg KH wrote:
>
>> On Tue, Jan 24, 2012 at 05:43:50PM +0100, Paolo Bonzini wrote:
>> > > You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENOIOCTLCMD from
>> > > sd_compat_ioctl, because -ENOIOCTLCMD will not be handled correctly by
>> > > block/ioctl.c.  This would break BLKROSET and BLKFLSBUF done by non-root
>> > > but with the appropriate capabilities.
>> > >
>> > > Fixed patch follows.  If you prefer that I send an interdiff, let me know.
>>
>> Wait, why do you want the stable trees to diverge from what is in
>> Linus's tree with regards to the error codes being returned?
>>
>> That doesn't seem safe, or sane.
>>
>> So for now, I'm going to follow what is in Linus's tree.  If you
>> need/want the error codes to be different, then shouldn't it also be
>> done there as well?
>
> May be because the stable trees do not have
> 07d106d0a33d6063d2061305903deb02489eba20? "vfs: fix up ENOIOCTLCMD error
> handling"?

I believe that is the case, yes.  Linus was unhappy about ENOIOCTLCMD vs.
ENOTTY overall when the patch was first submitted, which lead to that commit.
The patches Paolo submitted for stable are the original versions that apply
directly to 3.2 and older.

07d106d0a isn't really stable material as it was put into 3.3 to catch any odd
fallout from the change.

josh
