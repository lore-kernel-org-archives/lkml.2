Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2KMQfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:35:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab2KMQfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:35:20 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v3] loop: Limit the number of requests in the bio list
References: <1352824065-6734-1-git-send-email-lczerner@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 13 Nov 2012 11:35:07 -0500
In-Reply-To: <1352824065-6734-1-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Tue, 13 Nov 2012 17:27:45 +0100")
Message-ID: <x49y5i5cvgk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> Currently there is not limitation of number of requests in the loop bio
> list. This can lead into some nasty situations when the caller spawns
> tons of bio requests taking huge amount of memory. This is even more
> obvious with discard where blkdev_issue_discard() will submit all bios
> for the range and wait for them to finish afterwards. On really big loop
> devices and slow backing file system this can lead to OOM situation as
> reported by Dave Chinner.
>
> With this patch we will wait in loop_make_request() if the number of
> bios in the loop bio list would exceed 'nr_congestion_on'.
> We'll wake up the process as we process the bios form the list. Some
> threshold hysteresis is in place to avoid high frequency oscillation.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Dave Chinner <dchinner@redhat.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
