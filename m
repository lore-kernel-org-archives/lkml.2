Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1EBQLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:11:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab1EBQLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:11:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 3/3] blkdev: honor discard_granularity in blkdev_issue_discard()
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
	<1304345841-20063-3-git-send-email-lczerner@redhat.com>
	<yq17ha94175.fsf@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 02 May 2011 12:10:41 -0400
In-Reply-To: <yq17ha94175.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Mon, 02 May 2011 10:38:38 -0400")
Message-ID: <x49aaf5ozge.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
>
> Lukas> As Jeff Moyer pointed out we do not honor discard granularity
> Lukas> while submitting REQ_DISCARD bios of size smaller than
> Lukas> max_discard_sectors.  That fact might have unwanted consequences
> Lukas> of device ignoring the request, or even worse if device firmware
> Lukas> is buggy.
>
> We've discussed this before and the consensus was not to do it. The
> granularity is a hint, not a hard limit like max_discard_sectors.
>
> We want the reporting to be comprehensive throughout the block layer. If
> we start aligning to the granularity at the top we lose information for
> stacked devices below with a finer granularity.
>
> So if we were to align to the granularity we'd want to do it at the
> bottom of the stack when we issue the command to the device. We've had a
> few proposed patches to did that but so far we've only found one device
> where it made a difference. And that case didn't justify adding a quirk.

Hm, I wonder where it makes sense to document this.  Maybe
Documentation/block/queue-sysfs.txt, but I admit I wouldn't have looked
there while reviewing this code.

Cheers,
Jeff
