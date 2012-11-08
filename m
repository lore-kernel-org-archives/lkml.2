Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2KHW11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:27:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab2KHW1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:27:25 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: axboe@kernel.dk, dchinner@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] loop: Limit the number of requests in the bio list
References: <1350379305-13858-1-git-send-email-lczerner@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 08 Nov 2012 16:53:01 -0500
In-Reply-To: <1350379305-13858-1-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Tue, 16 Oct 2012 11:21:45 +0200")
Message-ID: <x49k3tvrcci.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> +	if (lo->lo_bio_count >= lo->lo_queue->nr_requests) {
> +		unsigned int nr;
> +		spin_unlock_irq(&lo->lo_lock);
> +		nr = lo->lo_queue->nr_requests - (lo->lo_queue->nr_requests/8);
> +		wait_event_interruptible(lo->lo_req_wait,
> +					 lo->lo_bio_count < nr);
> +		spin_lock_irq(&lo->lo_lock);
> +	}

So, blk_queue_make_request already initialized q->nr_congestion_on and
q->nr_congestion_off.  Is there a reason you didn't simply use
queue_congestion_on_threshold and queue_congestion_off_threshold?

Cheers,
Jeff
