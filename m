Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1LVSb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:31:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41016 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1LVSby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:31:54 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112221154380.11787@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com> <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com> <alpine.DEB.2.00.1112221154380.11787@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 10:31:31 -0800
X-Google-Sender-Auth: l2HdCvVeQ-X9pYfJgvJK_UxibfQ
Message-ID: <CA+55aFzY_6QYVyjAmP+w8D0Xy1Pq++XEUaBJRcCN9SbDE-pOhw@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 9:58 AM, Christoph Lameter <cl@linux.com> wrote:
>
> Subject: [percpu] Remove irqsafe_cpu_xxx variants

This looks good, but just remove the whole silly "xyz_op_return()" set
too. Don't even try to fix it up.

As far as I can tell, there are just a couple of users of that
horrible interface, it really isn't worth it. Just remove it and
opencode it. They are actually broken on x86 ('xadd' only exists if
CONFIG_X86_XADD is on - i386 didn't have it), and while most people
probably don't care (i386? What's that?), I note that the x86
add_return stuff doesn't take that into account.

If somebody cares about the end result of the add that much, they can
damn well just do it themselves.

                            Linus
