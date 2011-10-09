Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1JIUPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 16:15:06 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54568 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1JIUPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 16:15:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1107111033440.1752@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
	<20110705144140.23872.86541.stgit@localhost.localdomain>
	<alpine.LSU.2.00.1107071742250.10362@sister.anvils>
	<20110708093859.299958df@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107080917430.1781@sister.anvils>
	<20110711172517.46907e62@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107111033440.1752@sister.anvils>
Date: Sun, 9 Oct 2011 22:15:00 +0200
Message-ID: <CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device independant
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 7:49 PM, Hugh Dickins wrote:
> On Mon, 11 Jul 2011, Alan Cox wrote:
>> > Your <4GB pages won't get swapped out while they're pinned.  But can
>> > it happen that they'd be unpinned, swapped out, swapped back in >4GB
>> > pages, then cause trouble for you when needed again?
>>
>> It does look that way, in which case that will eventually need fixing. At
>> the moment you can't put enough memory into a device using these chips
>> but that won't always be true I imagine.
>
> Thanks, I won't worry about it at this moment, but we'd better not forget.
>
> If it's easy for you to include a WARN_ON_ONCE check (perhaps
> on page_to_pfn(page)), that may be worth doing to remind us.
>
> It's a bit sad to learn this requirement just after I'd completed
> removing the readpage copying code, and a bit strange to have shmem
> confined by hardware constraints; but I guess that's what we took on
> when we opened it up to GEM.
>
> It will probably make sense for me to add synchronous migration when
> a shmem swap page is found not to match the contraints wanted by the
> mapping it goes into: mainly for NUMA, but covering your case too.
>
> Hugh

I think we need to revisit this problem. On 3.1-rc4 with some of my own changes
I've just triggered read_cache_page_gfp in psb_gtt_attach_pages when trying to
set a resolution that doesn't fit in stolen memory. Replacing it with
shmem_read_mapping_page seems to work but how do we go about solving the >4GB
issue? Is it ok for now to just use shmem_read_mapping_page or did any of you
have a better solution?

Thanks
Patrik
