Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1DLOWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:22:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648Ab1DLOWO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik_9YW5+64FHrzNy7kPz1FUWrw-rw@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
 <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
 <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
 <alpine.LSU.2.00.1103182158200.18771@sister.anvils> <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
 <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
 <BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com> <BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
 <BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com> <BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
 <BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com> <BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com>
 <BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com> <alpine.LSU.2.00.1104060837590.4909@sister.anvils>
 <BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com> <BANLkTim0MZfa8vFgHB3W6NsoPHp2jfirrA@mail.gmail.com>
 <BANLkTim-hyXpLj537asC__8exMo3o-WCLA@mail.gmail.com> <alpine.LSU.2.00.1104070718120.28555@sister.anvils>
 <BANLkTik_9YW5+64FHrzNy7kPz1FUWrw-rw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 07:21:20 -0700
Message-ID: <BANLkTiniyAN40p0q+2wxWsRZ5PJFn9zE0Q@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 2:58 AM, Robert Święcki <robert@swiecki.net> wrote:
>
> So, if this case is not caught later on in the code, I guess it solves
> the problem. During the fuzzing I didn't experience any panic's, but
> some other problems arose, i.e. cannot read /proc/<pid>/maps for some
> processes (sys_read hangs, and such process cannot be killed or
> stopped with any signal, still it's running (R state) and using CPU -
> I'll submit another report for that).

Hmm. Sounds like an endless loop in kernel mode.

Use "perf record -ag" as root, it should show up very clearly in the report.

                          Linus
