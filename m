Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2BHQfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:35:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63024 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab2BHQfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:35:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120208162925.GA19392@google.com>
References: <20120206172706.GB21292@google.com> <4F303506.9000201@kernel.dk>
 <20120206215451.GD21292@google.com> <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com> <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com> <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com> <20120208162925.GA19392@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Feb 2012 08:34:53 -0800
X-Google-Sender-Auth: zsoUpFCyWYzY6ESDrgZPVctWKl8
Message-ID: <CA+55aFy8ym1KSFv753wGrYn8qG5eK6YOy_nOCpYiqPjoLJwysg@mail.gmail.com>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 8:29 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Can you please try the following one?  Thanks a lot!

If you can use it as a rwlock, why can't you do it with RCU?

Usually rwlocks are a bad idea. They tend to be more expensive than
spinlocks, and the extra parallelism is almost never noticeable
(except as "more cacheline bounces") for something that is appropriate
for a non-sleeping lock.

There's a *very* few situations where rwlock is the right thing, but
it really almost always is a horribly bad idea.

                     Linus
