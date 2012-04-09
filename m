Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2DIONx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:13:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044Ab2DIONV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:13:21 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]block: make auto block plug flush threshold per-disk based
References: <4F7F2765.3090003@kernel.org> <4F7F2A3D.3010700@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 09 Apr 2012 10:13:12 -0400
In-Reply-To: <4F7F2A3D.3010700@kernel.dk> (Jens Axboe's message of "Fri, 06
	Apr 2012 11:39:09 -0600")
Message-ID: <x498vi5803r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2012-04-06 11:27, Shaohua Li wrote:
>> We do auto block plug flush to reduce latency, the threshold is 16
>> requests. This works well if the task is accessing one or two drives.
>> The problem is if the task is accessing a raid 0 device and the raid
>> disk number is big, say 8 or 16, 16/8 = 2 or 16/16=1, we will have
>> heavy lock contention.
>> 
>> This patch makes the threshold per-disk based. The latency should be
>> still ok accessing one or two drives. The setup with application
>> accessing a lot of drives in the meantime uaually is big machine,
>> avoiding lock contention is more important, because any contention
>> will actually increase latency.
>
> Thanks, applied. It should have been per-queue all along, so this
> makes a lot of sense.

Yeah, I had noticed this before when looking over the code.  Makes
sense.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
