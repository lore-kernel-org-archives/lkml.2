Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2DJBgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab2DJBgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:36:15 -0400
Date: Tue, 10 Apr 2012 03:35:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm: account VMA before forced-COW via /proc/pid/mem
Message-ID: <20120410013549.GA19314@redhat.com>
References: <20120402153631.5101.44091.stgit@zurg> <20120403143752.GA5150@redhat.com> <4F7C1B67.6030300@openvz.org> <20120404154148.GA7105@redhat.com> <4F7D5859.5050106@openvz.org> <alpine.LSU.2.00.1204062104090.4297@eggly.anvils> <20120407173318.GA5076@redhat.com> <alpine.LSU.2.00.1204091734530.2079@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1204091734530.2079@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Hugh Dickins wrote:
>
> Let me reiterate here that I was off at a tangent in bringing this up,
> so sorry for any confusion I spread.

I guess it was me who added the confusion ;)

> > OTOH, if the file was opened without FMODE_WRITE, then I do not
> > really understand how (PROT_READ, MAP_SHARED) differs from
> > (PROT_READ, MAP_PRIVATE).

I meant, from gup(FOLL_FORCE|FOLL_WRITE) pov. I didn't mean mprotect/etc.

> The strange weird confusing part is that having checked that you have
> permission to write to the file, it then avoids doing so (unless the
> area currently has PROT_WRITE): it COWs pages for you instead,
> leaving unexpected anon pages in the shared area.

Yes, and we could do the same in (PROT_READ, MAP_SHARED) case.

This is what looks strange to me. We require PROT_WRITE to force-
cow, although we are not going (and shouldn't) write to the file.


But, to avoid even more confusion, I am not arguing with your
"limit the damage by making GUP write,force fail in that case"
suggestion. At least I do not think ptrace/gdb can suffer.

> > Speaking of the difference above, I'd wish I could understand
> > what VM_MAYSHARE actually means except "MAP_SHARED was used".
>
> That's precisely it: so it's very useful in /proc/pid/maps, for
> deciding whether to show an 's' or a 'p', but not so often when
> real decisions are made (where, as you've observed, private readonly
> and shared readonly are treated very similarly, without VM_SHARED).

Aha, thanks a lot.

Oleg.

