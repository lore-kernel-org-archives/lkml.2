Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2BGQdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:33:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38550 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2BGQdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:33:35 -0500
MIME-Version: 1.0
In-Reply-To: <4F315113.5010804@kernel.dk>
References: <1328514611.21268.66.camel@sli10-conroe> <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk> <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com> <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com> <4F303506.9000201@kernel.dk>
 <20120206215451.GD21292@google.com> <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com> <4F315113.5010804@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Feb 2012 08:33:15 -0800
X-Google-Sender-Auth: 4yC0nvfPP5dS-YYCEH0eh1kXxnI
Message-ID: <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 8:28 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> That was already merged in my tree. I don't see how it makes much
> difference in tracking the regression. You said that removing it made no
> difference for the find test case, so I'd be more comfortable getting
> rid of the nasty optimization.

Yeah, please just get rid of the crazy code. Maybe *that* fixes the
regression too, who knows?

For all we know, the "fast case" is what causes extra locking only to
then fail and not even be a fast-path.

I think our default action should always be to simplify and clean up
code, unless you have seriously hard numbers to show that the code
complexity is worth it.

                      Linus
