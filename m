Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0DZOIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0DZOIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:08:36 -0400
Date: Mon, 26 Apr 2010 16:06:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Tejun Heo <tj@kernel.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/9] PM: Add suspend blocking work.
Message-ID: <20100426140603.GA5702@redhat.com>
References: <1271984938-13920-2-git-send-email-arve@android.com> <1271984938-13920-3-git-send-email-arve@android.com> <1271984938-13920-4-git-send-email-arve@android.com> <1271984938-13920-5-git-send-email-arve@android.com> <1271984938-13920-6-git-send-email-arve@android.com> <1271984938-13920-7-git-send-email-arve@android.com> <1271984938-13920-8-git-send-email-arve@android.com> <4BD1576E.5070401@kernel.org> <20100423122032.GA23544@redhat.com> <y2ud6200be21004231549q8e52c9c0z441d82b5a15e177d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <y2ud6200be21004231549q8e52c9c0z441d82b5a15e177d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Arve Hjønnevåg wrote:
>
> On Fri, Apr 23, 2010 at 5:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > The unblock code in run_workqueue() is racy,
> > it can unblock after the work was queued on another CPU, cwq->lock can't
> > help.
>
> If the work is both queued and starts running on another workqueue
> between "get_wq_data(work) == cwq" and "!work_pending(work)", then
> suspend_unblock will be called when it shouldn't. It should work fine
> if I change to it check pending first though, since it cannot move
> back to the current workqueue without locking cwq->lock first.

It can be queued on the same or different workqueue on another CPU,
right before run_workqueue() does unblock.

But I guess this doesn't matter. You already discussed this all with
Tejun while I was sleeping ;) And I agree very much, the new plan looks
much better imho.

Oleg.

