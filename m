Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab2DIWah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:30:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52026 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229Ab2DIWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRRUNVn9_eL_obZxcZv7LqDW_8SeRApdKzDePbaW_Y4uvg@mail.gmail.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
 <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
 <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com> <CAMbhsRRUNVn9_eL_obZxcZv7LqDW_8SeRApdKzDePbaW_Y4uvg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Apr 2012 15:30:14 -0700
X-Google-Sender-Auth: ipkB_KfaW0qpaGQTI6RZ6YLGyXo
Message-ID: <CA+55aFw1OykVQOsKSABNOyyKZO5x4vB+zzw6U3dRbA6MyHdfoQ@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
To: Colin Cross <ccross@google.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 3:13 PM, Colin Cross <ccross@google.com> wrote:
>
> sched: Add a generic notifier when a task struct is about to be freed
> https://www.codeaurora.org/gitweb/quic/la/?p=kernel/common.git;a=commitdiff;h=667dffa787a87ef4ea43cc65957ce96077fdcd0a

Oh, *HELL*NO*!

It's a fucking disaster in "Oh, one notifier was broken, SO LET'S ADD
ANOTHER RANDOM ONE TO FIX THAT".

The definition of insanity is doing the same thing over and over and
thinking you get a different result. Let's not do that kind of idiotic
thing.

Notifiers are evil crap. Let's make *fewer* of them, not add
yet-another-random-notifier-for-some-random-reason.

F*ck me, but how I hate those random notifiers. And I hate people who
add them willy nilly.

                             Linus
