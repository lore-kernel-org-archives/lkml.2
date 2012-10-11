Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab2JKK3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:29:02 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57161 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421Ab2JKK26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVnHobvpiQA-doqaM7NrcZOkLO65JMF0+9RdZVQxkHGtA@mail.gmail.com>
References: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com>
	<1348652941-31899-2-git-send-email-maximlevitsky@gmail.com>
	<CAMuHMdVnHobvpiQA-doqaM7NrcZOkLO65JMF0+9RdZVQxkHGtA@mail.gmail.com>
Date: Thu, 11 Oct 2012 12:28:57 +0200
X-Google-Sender-Auth: BPWQsDEgkRxmcJ7KbzYoV5q-bfs
Message-ID: <CAMuHMdU1MRhgbqzgTGbJgK15=_BR3aE18UO_JpC_FtseJ9qM1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] scatterlist: add sg_nents
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 12:27 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, Sep 26, 2012 at 11:49 AM, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
>> +int sg_nents(struct scatterlist *sg)
>
> unsigned int?

and "const struct scatterlist *sg"? Ah no, that won't work as
sg_next() treats non-const pointers :-(

>> +{
>> +       int nents = 0;
>> +       while (sg) {
>> +               nents++;
>> +               sg = sg_next(sg);
>> +       }
>> +
>> +       return nents;
>> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
