Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab2EOPtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:49:01 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40492 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2EOPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <1337078996.27694.26.camel@twins>
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>
 <1337034048.27020.137.camel@laptop> <CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com>
 <1337078996.27694.26.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 08:48:38 -0700
X-Google-Sender-Auth: E6mlHz0N9hpL3Opv66G7VRSvvSM
Message-ID: <CA+55aFwkQUrsG6JFVuL5u_0waLPrYqsgHtKRnMHD-Tz0KivaNQ@mail.gmail.com>
Subject: Re: Perf events warning..
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 3:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> It did use "make -j64 test" to make the load a *bit* more interesting
>> (and go noticeably faster), but other than that you got it.
>
> OK, that limits the scope of crazy scenarios I have to consider, still
> no immediate clue though..

Actually, looking into my history, some of them had "-fg", and some of
them used "cycles:p". It looks like I had three different combinations
I used:

 - the one I already mentioned:

        perf record -f -e cycles:pp make -j64 test

 - two variations of the above:

        perf record -fg -e cycles:p make -j64 test
        perf record -fg -e cycles:pp make -j64 test

and I don't know which of these caused the warning.

I did profile some other things too (I commonly do profiles of "git
diff" and "make -j" on a fully built kernel), but they used the same
flags, so from a perf standpoint they shouldn't be all that different.

                     Linus
