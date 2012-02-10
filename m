Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2BJTdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:33:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37183 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2BJTdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:33:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120210192714.GE4998@infradead.org>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
 <1328895795.25989.29.camel@laptop> <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
 <20120210192714.GE4998@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 11:32:42 -0800
X-Google-Sender-Auth: 15PxHoS-UeluadHIaisbm0o0tYc
Message-ID: <CA+55aFx9wxNkiW7QSLAmo+cAOOUjZef6a8xBfw88Wn+Nd9viNQ@mail.gmail.com>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:27 AM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
>
> "Vote for --fno-omit-frame-pointer! One register is a cheap price to pay
> for not going insane!"
>
> /me goes back to non political things.

Even with -fomit-frame-pointer (which seems to be a big deal on Atom
in particular), the call frames really don't look that horrible even
when we guess. And seeing the occasional stale pointer can often give
hints about what the thing was doing before, so it's not even
horrible.

The biggest problem actually seems to often be some gcc versions that
allocate a *lot* of stack space for some functions and then never
really use it. That ends up then letting *tons* of really old stale
code pointers "shine through".

Sometimes it's our code that just has horrible stack usage with crazy
worst-case allocations or something. We've fixed a few of them, it
seems to be getting better.

               Linus
