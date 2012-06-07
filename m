Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2FGPad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:30:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50927 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2FGPac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:30:32 -0400
MIME-Version: 1.0
In-Reply-To: <1339064814.23343.14.camel@twins>
References: <20120603223617.GB7707@redhat.com> <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk> <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com> <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <1339064814.23343.14.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 08:30:10 -0700
X-Google-Sender-Auth: Pv2yyrwBYnB2WfNV25G8lfN8gGc
Message-ID: <CA+55aFycTypSSvjOB-KXzpK86ALifGbrO2s4HRc69CqyoX=qJA@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 3:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-06-06 at 16:31 -0700, Linus Torvalds wrote:
>> PeterZ - the fact that we use mutex_lock_nested with
>> I_MUTEX_PARENT/I_MUTEX_CHILD/nothing hopefully doesn't screw us up in
>> case we get it wrong, right?
>
> Sadly, if you get that annotation wrong you can annotate an actual
> deadlock away. This the reason you have to be very careful when
> annotating stuff.

Is that true even if you can see an actual deadlock on the lock *instances*?

The point of the locking classes (to me) was always that you could see
the deadlock even if it didn't *actually* happen, just *potentially*
happened. If the lock classes then mean that that hides an actual
deadlock information, that's a big downside.

And yeah, that really means that we absolutely *have* to get the
instance data in the lock debug printout, since we can't see deadlocks
any other way. Can you check the compile error that Dave reported for
your patch, because right now Dave is running without it, afaik, due
to your lock-instance patch not really working in practice.

                Linus
