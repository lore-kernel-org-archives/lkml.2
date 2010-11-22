Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0KVAbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:31:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33109 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab0KVAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UUFypwtc+EwBbjjqIz6bQBIiKZDxYOCeQN1H6oM2LdOoy5a4SZBSsW+xdYfJ9kojuN
         9qVhTouhbf5vgpNBbzR/oUcG11C7uA/x8kyI8OmuydFCADwZR8USRuj3ZqWgjXZ+4iZO
         WoPsS821d/+CJgaGo8RU+2mJxTU0ra/NhFu2Y=
MIME-Version: 1.0
In-Reply-To: <87tyjavdn2.fsf@gmail.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<5d205f8a4df078b0da3681063bbf37382b02dd23.1290349672.git.minchan.kim@gmail.com>
	<87tyjavdn2.fsf@gmail.com>
Date: Mon, 22 Nov 2010 09:31:09 +0900
Message-ID: <AANLkTikWz6kmgwebUsO--hohSFG__Uwpxp=JZ70Vwr=t@mail.gmail.com>
Subject: Re: [RFC 2/2] Prevent promotion of page in madvise_dontneed
From: Minchan Kim <minchan.kim@gmail.com>
To: Ben Gamari <bgamari@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 1:34 AM, Ben Gamari <bgamari@gmail.com> wrote:
> On Sun, 21 Nov 2010 23:30:24 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
>> Now zap_pte_range alwayas promotes pages which are pte_young &&
>> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
>> it's unnecessary since the page wouldn't use any more.
>>
> Is this not against master? If it is, I think you might have forgotten
> to update the zap_page_range() reference on mm/memory.c:1226 (in
> zap_vma_ptes()). Should promote be true or false in this case? Cheers,

Thanks. I missed that. Whatever, It's okay. :)
That's because it is used by only VM_PFNMAP.
It means the VMA doesn't have struct page descriptor of pages.
So zap_pte_range never promote the page.

Anyway, by semantic, it should be "zero".
Will fix.
Thanks, Ben.

>
> - Ben
>



-- 
Kind regards,
Minchan Kim
