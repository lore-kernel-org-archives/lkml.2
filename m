Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2BISH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:07:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65049 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2BISHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:07:55 -0500
MIME-Version: 1.0
In-Reply-To: <20120209175948.GE19392@google.com>
References: <20120206215451.GD21292@google.com> <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com> <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com> <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
 <20120208162925.GA19392@google.com> <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
 <20120209175948.GE19392@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 10:07:35 -0800
X-Google-Sender-Auth: aBIup4S60mVjmw46X3VtBHnKRHo
Message-ID: <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
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

On Thu, Feb 9, 2012 at 9:59 AM, Tejun Heo <tj@kernel.org> wrote:
>
> * What exactly is the test and what do you measure?  What does "12%
>  regression" mean?  Is it wallclock time or CPU time?  If it's CPU
>  time, does systime increase dominate the regression?

Shaohua, it might be interesting to see a profile of the bad case.

Now, quite often these kinds of things don't show anything at all -
it's just due to cache issues and there's no obvious "we hold spinlock
X for 15 seconds total". But if it's actual lock contention rather
than just "more scheduling of worker threads", it should show up in
the profile quite clearly.

That said, I do think the RCU approach is the right one. The whole
delayed deallocation (and the replacement patch with rwlocks) really
smells like "badly done RCU-like behavior" to me.

                  Linus
