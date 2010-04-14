Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0DNPMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:12:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61969 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0DNPMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t/EETIyO1RQuwfL1MdZdwIjNW8vlyNQ/wPOCAn5Dph6zxcmfSTtFVio4rAdqM52S7q
         iVFbX8ardYy0PCwXWePSR9fAMmGfiUQ4Jqm9pwglFhb6JL8vMLdZGW0lmw4Km7HXl61w
         v0cF9suy793GwAyOgK4eAeDWG2bd24PE9RF/o=
MIME-Version: 1.0
In-Reply-To: <1271255053.7196.89.camel@localhost.localdomain>
References: <1271089672.7196.63.camel@localhost.localdomain>
	 <1271249354.7196.66.camel@localhost.localdomain>
	 <1271255053.7196.89.camel@localhost.localdomain>
Date: Thu, 15 Apr 2010 00:12:45 +0900
Message-ID: <h2m28c262361004140812y92447e97z29c001d0a8b8eaaf@mail.gmail.com>
Subject: Re: vmalloc performance
From: Minchan Kim <minchan.kim@gmail.com>
To: Steven Whitehouse <steve@chygwyn.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 11:24 PM, Steven Whitehouse <steve@chygwyn.com> wrote:
> Hi,
>
> Also, what lock should be protecting this code:
>
>        va->flags |= VM_LAZY_FREE;
>        atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT,
> &vmap_lazy_nr);
>
> in free_unmap_vmap_area_noflush() ? It seem that if
> __purge_vmap_area_lazy runs between the two statements above that the
> number of pages contained in vmap_lazy_nr will be incorrect. Maybe the
> two statements should just be reversed? I can't see any reason that the
> flag assignment would be atomic either. In recent tests, including the
> patch below, the following has been reported to me:

It was already fixed.
https://patchwork.kernel.org/patch/89783/

Thanks.

-- 
Kind regards,
Minchan Kim
