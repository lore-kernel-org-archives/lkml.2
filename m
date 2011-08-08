Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1HHR70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:59:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1HHR7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:59:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/11] DIO: Separate fields only used in the submission path from struct dio
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-2-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 13:59:08 -0400
In-Reply-To: <1312259893-4548-2-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:03 -0700")
Message-ID: <x497h6niy37.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> This large, but largely mechanic, patch moves all fields in struct dio
> that are only used in the submission path into a separate on stack
> data structure. This has the advantage that the memory is very likely
> cache hot, which is not guaranteed for memory fresh out of kmalloc.
>
> This also gives gcc more optimization potential because it can easier
> determine that there are no external aliases for these variables.
>
> The sdio initialization is a initialization now instead of memset.
> This allows gcc to break sdio into individual fields and optimize
> away unnecessary zeroing (after all the functions are inlined)
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

The pages array is only used on submission.  Why did it land in the
struct dio?  I would also think you'd want to keep it close to
curr_page, head, tail.

Cheers,
Jeff
