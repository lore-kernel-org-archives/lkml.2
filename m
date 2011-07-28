Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1G1UVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab1G1UVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:21:20 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Namhyung Kim" <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] blktrace: add FLUSH/FUA support
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 28 Jul 2011 16:21:14 -0400
Message-ID: <x494o26ma11.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, I don't have the original posting of this message, so I've just
cut-n-paste from the archives on lkml.org:
  https://lkml.org/lkml/2011/6/1/235

The proposal was this:

> Add FLUSH/FUA support to blktrace. As FLUSH precedes WRITE and/or
> FUA follows WRITE, use the same 'F' flag for both cases and
> distinguish them by their (relative) position. The end results
> look like (other flags might be shown also):
> 
>  - WRITE:            W
>  - WRITE_FLUSH:      FW
>  - WRITE_FUA:        WF
>  - WRITE_FLUSH_FUA:  FWF

I'm not sure I'll ever be able to keep that straight.  How about we use
'F' for FUA, since FUA is capitalized anyway, and use 'f' for flush?
Too subtle?

Next...

> @@ -14,7 +14,7 @@
>  enum blktrace_cat {
>  	BLK_TC_READ	= 1 << 0,	/* reads */
>  	BLK_TC_WRITE	= 1 << 1,	/* writes */
> -	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
> +	BLK_TC_FUA	= 1 << 2,	/* fua requests */

I would prefer to replace BARRIER with FLUSH, as I think they are closer
relatives.  Doing it the way you've suggested would mean that older
blktrace user-space would report FUA as a Barrier.

Comments?  No matter what's agreed upon, we should get this in sooner
rather than later, as it's a big missing piece in trying to diagnose
performance issues!

Cheers,
Jeff
