Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2ECOin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:38:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab2ECOik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:38:40 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Venkatraman S <svenkatr@ti.com>
Cc: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v2 06/16] block: treat DMPG and SWAPIN requests as special
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
	<1336054995-22988-7-git-send-email-svenkatr@ti.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 May 2012 10:38:10 -0400
In-Reply-To: <1336054995-22988-7-git-send-email-svenkatr@ti.com> (Venkatraman
	S.'s message of "Thu, 3 May 2012 19:53:05 +0530")
Message-ID: <x49fwbhl48d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatraman S <svenkatr@ti.com> writes:

> From: Ilan Smith <ilan.smith@sandisk.com>
>
> When exp_swapin and exp_dmpg are set, treat read requests
> marked with DMPG and SWAPIN as high priority and move to
> the front of the queue.
>
[...]
> +	if (bio_swapin(bio) && blk_queue_exp_swapin(q)) {
> +		spin_lock_irq(q->queue_lock);
> +		where = ELEVATOR_INSERT_FLUSH;
> +		goto get_rq;
> +	}
> +
> +	if (bio_dmpg(bio) && blk_queue_exp_dmpg(q)) {
> +		spin_lock_irq(q->queue_lock);
> +		where = ELEVATOR_INSERT_FLUSH;
> +		goto get_rq;

Is ELEVATOR_INSERT_FRONT not good enough?  It seems wrong to use _FLUSH,
here.  If the semantics of ELEVATOR_INSERT_FLUSH are really what is
required, then perhaps we need to have another think about the naming of
these flags.

Cheers,
Jeff
