Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1AZQ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:29:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1AZQ3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:29:42 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org
Subject: Re: [PATCH UPDATED 21/32] fs/aio: aio_wq isn't used in memory reclaim path
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-22-git-send-email-tj@kernel.org>
	<20110126112154.GM12520@htj.dyndns.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 26 Jan 2011 11:29:36 -0500
In-Reply-To: <20110126112154.GM12520@htj.dyndns.org> (Tejun Heo's message of
	"Wed, 26 Jan 2011 12:21:54 +0100")
Message-ID: <x491v3zzkzz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> aio_wq isn't used during memory reclaim.  Convert to alloc_workqueue()
> without WQ_MEM_RECLAIM.  It's possible to use system_wq but given that
> the number of work items is determined from userland and the work item
> may block, enforcing strict concurrency limit would be a good idea.
>
> Also, move fput_work to system_wq so that aio_wq is used soley to
> throttle the max concurrency of aio work items and fput_work doesn't
> interact with other work items.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Jeff Moyer <jmoyer@redhat.com>

You actually missed that CC.  ;-)

> Cc: linux-aio@kvack.org
> ---
> Patch description updated to describe fput_work change.  If there's no
> further objection, I'll push it through workqueue#for-2.6.39.  Thanks.

Looks good to me, based on not changing existing semantics.

Acked-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,
Jeff
