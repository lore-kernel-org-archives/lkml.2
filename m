Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2CVCjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:39:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61160 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2CVCjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <yq18vitwejt.fsf@sermon.lab.mkp.net>
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	<4F69C62C.7020604@kernel.org>
	<yq18vitwejt.fsf@sermon.lab.mkp.net>
Date: Thu, 22 Mar 2012 10:39:19 +0800
X-Google-Sender-Auth: wsOik5mo4O4U9noSqrsFcqQz5Us
Message-ID: <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
Subject: Re: [patch 1/2]block: handle merged discard request
From: Shaohua Li <shli@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/22 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:
>
> Shaohua> The SCSI discard implementation hacks the first bio of request
> Shaohua> to add payload, which makes blk_update_request() can't
> Shaohua> correctly mark bios finish.  The patch solves it. We set
> Shaohua> discard bio size to 0 and finish it after the hacked payload
> Shaohua> finishes.
>
> Ick!
>
> Also, you can't muck with bi_size because if we get an I/O error and
> have to reissue the command we no longer know how much to write.
> I have had to deal with the same issue for WRITE SAME. And the only sane
> approach is to distinguish between the DMA transfer size and the blocks
> "affected" by the command. That's what I'm working on right now for copy
> offload...
Yes, this is a problem. But note we already have this problem with
discard request for a long time. The payload has just (sector, length).
And looks the request finish returns the transfered data of the
payload instead of the discarded data. Am I missing anything?

> If this is something you want in 3.4 I guess we could temporarily add a
> separate length field to struct request. If you can wait I suggest we
> talk at LSF.
This blocked my raid discard patches, but I can wait. Sure we can have
a talk at LSF.

Thanks,
Shaohua
