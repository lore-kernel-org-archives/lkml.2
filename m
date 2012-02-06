Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2BFQ7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:59:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60071 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab2BFQ7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:59:09 -0500
MIME-Version: 1.0
In-Reply-To: <20120206164428.GA21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe> <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk> <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Feb 2012 08:58:49 -0800
X-Google-Sender-Auth: mGaCORB_WAF-qSlVtN65PYLzvBY
Message-ID: <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
Subject: Re: [patch]block: fix ioc locking warning
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 8:44 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Yeah, this seems better to me.  Jens, if you're gonna amend the
> commit, please consider collapsing the following patch into the
> original patch too.  Thanks.

Guys, is it *really* worth it to do all these crazy games?

How bad is it to just always use the async freeing, instead of this
clearly very fragile crazy direct-freeing-with-serious-locking-issues
thing?

Sure, even ioc_release_fn() isn't trivial wrt lock handling, but at
least it doesn't have to play these *insane* games with recursive
locking.

And if workqueues are too expensive, what saner alternatives might
there be? This code really is insane.

                Linus
