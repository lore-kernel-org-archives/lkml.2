Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1INGtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 02:49:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56708 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1INGtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 02:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx41_Z4TjjJwPuE21Q8oD3aGWtQwh45DUiCjPVD-wCJXw@mail.gmail.com>
References: <1315941801.2565.19.camel@edumazet-laptop> <CA+55aFx41_Z4TjjJwPuE21Q8oD3aGWtQwh45DUiCjPVD-wCJXw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Sep 2011 23:48:58 -0700
X-Google-Sender-Auth: xDOkjA6xrVFt-MOgqPv82M5kqs0
Message-ID: <CA+55aFyF4Tr0BNXhuka2FjGAOn2oYoBvX=nUjueCvLezyf2XKQ@mail.gmail.com>
Subject: Re: [BUG] infinite loop in find_get_pages()
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, sorry for the possible duplicates - but it looks like my email
hasn't been going out.

                      Linus

On Tue, Sep 13, 2011 at 6:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Sep 13, 2011 at 12:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> while :
>> do
>>  echo 3 >/proc/sys/vm/drop_caches
>>  sleep 20
>> done
>
> Btw, do you actually have problems without this?
>
> The drop_caches thing could potentially result in a livelock, where
> we're dropping stuff as we are reading it in, and the reader just
> never makes progress (because dropping things is always faster than
> reading).
>
> So it may not be a "true lockup", it may just be really *really* slow,
> and wasting tons of CPU.
>
> It is possible that we should look at modifying the drop_caches code
> so that it always makes forward progress..
>
>                            Linus
>
