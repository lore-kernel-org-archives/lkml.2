Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab0KWE5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 23:57:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53607 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0KWE5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 23:57:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=svoYIo2EWY66N+oBRksXMG9TmltTPXYEYrFcz7whNVe9xLDTlsYjJ1F3QYtf2+zhXD
         YVnIZbsMSXbWGxQ0iNdpVo2ST2cCmBSX+BBEmnD+W9mczTUKIVhlkQj11Wyif8XKabF8
         q2/LGF94AIReUZD0dWKu5+TKe2y3KeuPmfJFg=
MIME-Version: 1.0
In-Reply-To: <20101122142109.2f3e168c.akpm@linux-foundation.org>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<5d205f8a4df078b0da3681063bbf37382b02dd23.1290349672.git.minchan.kim@gmail.com>
	<20101122142109.2f3e168c.akpm@linux-foundation.org>
Date: Tue, 23 Nov 2010 13:57:17 +0900
Message-ID: <AANLkTimm9KzAYBecikb4WqnRCo-Gw5eJdSD5dhX5ObYa@mail.gmail.com>
Subject: Re: [RFC 2/2] Prevent promotion of page in madvise_dontneed
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 7:21 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 21 Nov 2010 23:30:24 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Now zap_pte_range alwayas promotes pages which are pte_young &&
>> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
>> it's unnecessary since the page wouldn't use any more.
>>
>> If the page is sharred by other processes and it's real working set
>
> This patch doesn't actually do anything.  It passes variable `promote'
> all the way down to unmap_vmas(), but unmap_vmas() doesn't use that new
> variable.

Oops. Sorry for that.
I will resend the patch with your fixlet and Ben's point.
Thank you.

> Have a comment fixlet:
>
> --- a/mm/memory.c~mm-prevent-promotion-of-page-in-madvise_dontneed-fix
> +++ a/mm/memory.c
> @@ -1075,7 +1075,7 @@ static unsigned long unmap_page_range(st
>  * @end_addr: virtual address at which to end unmapping
>  * @nr_accounted: Place number of unmapped pages in vm-accountable vma's here
>  * @details: details of nonlinear truncation or shared cache invalidation
> - * @promote: whether pages inclued vma would be promoted or not
> + * @promote: whether pages included in the vma should be promoted or not
>  *
>  * Returns the end address of the unmapping (restart addr if interrupted).
>  *
> _
>
> Also, I'd suggest that we avoid introducing the term "promote".  It
> isn't a term which is presently used in Linux MM.  Probably "activate"
> has a better-known meaning.
>
> And `activate' could be a bool if one is in the mood for that.
>



-- 
Kind regards,
Minchan Kim
