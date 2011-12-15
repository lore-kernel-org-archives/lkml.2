Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1LOHUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:20:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52696 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1LOHUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:20:20 -0500
MIME-Version: 1.0
In-Reply-To: <20111215070857.GD14237@elte.hu>
References: <20111214223925.GA27578@www.outflux.net>
	<20111215070857.GD14237@elte.hu>
Date: Wed, 14 Dec 2011 23:20:20 -0800
X-Google-Sender-Auth: DAy2QdFvxmUqwuFhCP85kJvTnco
Message-ID: <CAGXu5jLEiB4i1_WCkDz3MDM=LBKKWB_cqhOWcpzEYAon0YZp8w@mail.gmail.com>
Subject: Re: [PATCH] sched: mark parent and real_parent as __rcu
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Kees Cook <keescook@chromium.org> wrote:
>
>> The parent and real_parent pointers should be considered __rcu, since
>> they should be held under either tasklist_lock or rcu_read_lock.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  include/linux/sched.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> Did you get some warning that alerted you to this problem? If
> yes then please include it in the changelog, so that people
> hitting the message can easily find it.
>
> Same consideration applies the second patch as well.

No, this was via code inspection related to reviews of the Yama LSM's
use of these structures and comparing the RCU and tasklist_lock
behavior/requirements seen in the rest of the kernel. Most attempts at
using sparse after this change were not very successful due to the
high volume of unrelated noise currently seen with "make C=2", but I
was able to confirm that the apparmor and tomoyo patches were flagged
by sparse, at least. When this __rcu marking is in place, if there is
a place that might need rcu_dereference, it would show up as "warning:
dereference of noderef expression".

-Kees

-- 
Kees Cook
ChromeOS Security
