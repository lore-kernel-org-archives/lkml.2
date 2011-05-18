Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1ERKJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:09:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab1ERKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110516114254.GI19837@elte.hu>
References: <1305210630-7136-1-git-send-email-jolsa@redhat.com> <20110516114254.GI19837@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2011 03:08:54 -0700
Message-ID: <BANLkTinALOXLa1HYyCQBwYcBo=N0eVcPUg@mail.gmail.com>
Subject: Re: [PATCH] x86, x86_64: Fix checks for userspace address limit
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 4:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Hm, something tickles me about this area that we would reintroduce a security
> hole, that we really wanted to treat the last page of user-space as some sort
> of guard page but i cannot quite remember it why ...
>
> IIRC Linus wrote bits of this so i'm Cc:-ing him just in case he remembers.

No, I suspect the patch is correct, and it's just a bug. I think it
comes from the "get_user_X()" cases that afaik use "jae" because they
add one less than the size (and thus avoid it entirely for the
single-byte case). See "getuser.S" in the same directory.

But right now I think I need to do a 2.6.39 release later today (after
I get some sleep), so doing it as a stable patch (presumably going
back to pretty much the beginning of time) is probably the right
thing.

              Linus
