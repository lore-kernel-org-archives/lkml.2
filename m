Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1HHSLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:11:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab1HHSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:11:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/11] DIO: Separate map_bh from dio v2
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-6-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 14:11:44 -0400
In-Reply-To: <1312259893-4548-6-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:07 -0700")
Message-ID: <x49pqkfhixr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> Only a single b_private field in the map_bh buffer head is needed after
> the submission path. Move map_bh separately to avoid storing
> this information in the long term slab.
>
> This avoids the weird 104 byte hole in struct dio_submit which also needed
> to be memseted early.
>
> v2: b_private->private (hch)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

> @@ -1045,6 +1051,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
>  	ssize_t ret = 0;
>  	ssize_t ret2;
>  	size_t bytes;
> +	struct buffer_head map_bh = { 0, };

So long as that zeroes the entire struct (seems to), I'm okay with this patch.

Cheers,
Jeff
