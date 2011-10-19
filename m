Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab1JSNkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:40:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55276 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1JSNkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <20111019074336.GB3410@suse.de>
References: <201110122012.33767.pluto@agmk.net> <alpine.LSU.2.00.1110131547550.1346@sister.anvils>
 <alpine.LSU.2.00.1110131629530.1410@sister.anvils> <20111016235442.GB25266@redhat.com>
 <alpine.LSU.2.00.1110171111150.2545@sister.anvils> <20111019074336.GB3410@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Oct 2011 06:39:55 -0700
X-Google-Sender-Auth: kxlVRQ_w98xogqjWxGgnBaxSL6M
Message-ID: <CA+55aFwf75oJ3JJ2aCR8TJJm_oLireD6SDO+43GveVVb8vGw1w@mail.gmail.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 12:43 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> My vote is with the migration change. While there are occasionally
> patches to make migration go faster, I don't consider it a hot path.
> mremap may be used intensively by JVMs so I'd loathe to hurt it.

Ok, everybody seems to like that more, and it removes code rather than
adds it, so I certainly prefer it too. Paweł, can you test that other
patch (to mm/migrate.c) that Hugh posted? Instead of the mremap vma
locking patch that you already verified for your setup?

Hugh - that one didn't have a changelog/sign-off, so if you could
write that up, and Paweł's testing is successful, I can apply it...
Looks like we have acks from both Andrea and Mel.

                  Linus
