Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1HOLzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:55:16 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42823 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1HOLzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:55:14 -0400
MIME-Version: 1.0
In-Reply-To: <4E4903C1.9050207@parallels.com>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
	<1313334832-1150-4-git-send-email-glommer@parallels.com>
	<CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>
	<20110815104656.GG26978@dastard>
	<CAOJsxLGFJmqO-W=itQbO4Mh4DxSD4wrHOC8gQ5bWL5aE1YYeQw@mail.gmail.com>
	<4E48FD8A.90401@parallels.com>
	<CAOJsxLFjZffC9i5kQsBWjGy3eWdj3VMB5awz=yPcwgeKb5BG0Q@mail.gmail.com>
	<4E4903C1.9050207@parallels.com>
Date: Mon, 15 Aug 2011 14:55:13 +0300
X-Google-Sender-Auth: igUDZhqgAek0mwf9D8hT7a5sRr0
Message-ID: <CAOJsxLErFcxuuqnWkRbOAHEFbeGrKp3YMZ-144=m16oBXCHJ2g@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
From: Pekka Enberg <penberg@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <jbottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 2:32 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
>> Couldn't you simply do per-container "struct kmem_accounted_cache" in struct superblock?
>
> If by this you mean "account for all the kmem associated with particular superblock" then
> this is OK for us, but this can't be done in a simple
>
>        if (used + size > limit)
>                return -ENOMEM
>        else {
>                used += size;
>                return 0;
>        }
>
> manner, since once we hit the limit we should shrink the unused dentries. And most of the
> patches are about this.

So you want to shrink dentries that were allocated in the container
that hit the dcache limit? How does this patch set deal with that? Or
are you referring to some other patches?

                         Pekka
