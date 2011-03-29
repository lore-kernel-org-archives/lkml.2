Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1C2ONU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:13:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab1C2ONU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:13:20 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE (was: Re: elevator private data for REQ_FLUSH)
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
	<20110325152228.GA1707@gentoo.trippels.de>
	<20110325154024.GA16029@redhat.com> <4D8CB9C9.5010208@kernel.dk>
	<20110325185455.GA2969@redhat.com> <4D8CF202.9010809@kernel.dk>
	<20110326042156.GB28458@redhat.com>
	<20110328082321.GC16530@htj.dyndns.org>
	<20110328221547.GA1118@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 29 Mar 2011 10:13:05 -0400
In-Reply-To: <20110328221547.GA1118@redhat.com> (Mike Snitzer's message of
	"Mon, 28 Mar 2011 18:15:47 -0400")
Message-ID: <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> writes:

> OK, I came up with the following patch.
>
> Jens, this is just a natural cleanup given the code that resulted from
> the flush-merge and onstack plugging changes coming together.
>
>
> From: Mike Snitzer <snitzer@redhat.com>
> Subject: block: eliminate ELEVATOR_INSERT_REQUEUE
>
> elv_insert() no longer has a need to differentiate between
> ELEVATOR_INSERT_REQUEUE and ELEVATOR_INSERT_FRONT.  The onstack plugging
> changes eliminated the need to avoid unplugging the queue (via
> ELEVATOR_INSERT_REQUEUE).
>
> Also, in blk_insert_flush(), use elv_insert() with ELEVATOR_INSERT_FRONT
> rather than open-coding the equivalent.

What you change by doing the call to elv_insert is that now the request
will have REQ_SOFTBARRIER set.  I don't think that affects anything,
though (I checked).  The rest looks pretty straight-forward.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
