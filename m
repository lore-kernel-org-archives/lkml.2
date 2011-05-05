Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1EEBlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 21:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab1EEBlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 21:41:13 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik-s3Gr6GDMN4L24wX2BK9n3okzQA@mail.gmail.com>
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
 <BANLkTik_9YW5+64FHrzNy7kPz1FUWrw-rw@mail.gmail.com> <BANLkTiniyAN40p0q+2wxWsRZ5PJFn9zE0Q@mail.gmail.com>
 <BANLkTik6U21r91DYiUsz9A0P--=5QcsBrA@mail.gmail.com> <BANLkTim6ATGxTiMcfK5-03azgcWuT4wtJA@mail.gmail.com>
 <BANLkTiktvcBWsLKEk5iBYVEbPJS3i+U+hA@mail.gmail.com> <BANLkTikdM2kF=qOy4d4bZ_wfb5ykEdkZPQ@mail.gmail.com>
 <BANLkTikZ1szdH5HZdjKEEzG2+1VPusWEeg@mail.gmail.com> <BANLkTingV3eiHEco+36YyM4YTDHFHc9_jA@mail.gmail.com>
 <BANLkTi=D+oe_zyxA1Oj5S36F6Tk0J+26iQ@mail.gmail.com> <BANLkTim_QtaQLa9GV5hMZyCmW_WAz_Ucvg@mail.gmail.com>
 <BANLkTik-s3Gr6GDMN4L24wX2BK9n3okzQA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 18:40:49 -0700
Message-ID: <BANLkTi=gtiZU3W+UfkgaygURtVWNE6qyEw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
To: Michel Lespinasse <walken@google.com>
Cc: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 6:18 PM, Michel Lespinasse <walken@google.com> wrote:
>
> I think we want the mm/memory.c part of this proposal without the
> mm/mlock.c part.

.. but what about mlock not setting the FOLL_MLOCK bit, then?

In that case, you'd get the "mlock extends the stack" problem.

                         Linus
