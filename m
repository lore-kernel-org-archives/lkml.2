Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2HXK2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:28:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60366 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398Ab2HXK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:28:07 -0400
Date: Fri, 24 Aug 2012 11:27:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jim Meyering <jim@meyering.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Meyering <meyering@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] kmemleak: avoid buffer overrun: NUL-terminate
 strncpy-copied command
Message-ID: <20120824102725.GH7585@arm.com>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
 <1345481724-30108-4-git-send-email-jim@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345481724-30108-4-git-send-email-jim@meyering.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 05:55:22PM +0100, Jim Meyering wrote:
> From: Jim Meyering <meyering@redhat.com>
> 
> strncpy NUL-terminates only when the length of the source string
> is smaller than the size of the destination buffer.
> The two other strncpy uses (just preceding) happen to be ok
> with the current TASK_COMM_LEN (16), because the literals
> "hardirq" and "softirq" are both shorter than 16.  However,
> technically it'd be better to use strcpy along with a
> compile-time assertion that they fit in the buffer.
> 
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  mm/kmemleak.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 45eb621..947257f 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -555,6 +555,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
>  		 * case, the command line is not correct.
>  		 */
>  		strncpy(object->comm, current->comm, sizeof(object->comm));
> +		object->comm[sizeof(object->comm) - 1] = 0;

Does it really matter here? object->comm[] and current->comm[] have the
same size, TASK_COMM_LEN.

-- 
Catalin
