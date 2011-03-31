Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1CaFdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:33:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786Ab1CaFdB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:33:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110331035511.GA1255@redhat.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 22:32:11 -0700
Message-ID: <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 8:55 PM, Dave Jones <davej@redhat.com> wrote:
>
> I tried that, and wasn't particularly enlightened.
>
> +      6.53%  kworker/1:2  [kernel.kallsyms]  [k] read_hpet
> +      4.83%  kworker/0:0  [kernel.kallsyms]  [k] read_hpet

Go into those, deeper into the callchain. That's how to see what the
upper-level problem is - by seeing who actually calls it. The leafs
themselves (where the time is obviously spent) don't tend to be very
informative, no.

>  > (Powertop can also do it, and is probably a better thing to use, I'm
>  > just used to "perf record" for other reasons, so..)
>
> Tried that too, here's what it said..

Hmm. Powertop is _supposed_ to be able to look into the kwork things
(it has special trace points for it), but as mentioned, the times I've
seen it I've used 'perf', so I haven't actually tried it myself.

                  Linus
