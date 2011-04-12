Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1DLTIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab1DLTIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:08:50 -0400
Date: Tue, 12 Apr 2011 21:07:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Cc: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] Was: Processes hang in an unkillable state
Message-ID: <20110412190731.GA13752@redhat.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com> <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com> <20110412182809.GA1218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110412182809.GA1218@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add cc's)

On 04/12, Oleg Nesterov wrote:
>
> On 04/12, Américo Wang wrote:
> >
> > Hmm, it must be stuck at
> >
> > lib/rwsem.c
> >
> >         /* wait to be given the lock */
> >         for (;;) {
> >                 if (!waiter.task)
> >                         break;
> >                 schedule();
> >                 set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> >         }
> >
> > don't know why it still can't acquire the ->mmap_sem...
> >
> > Cc'ing Oleg...
>
> I seem to understand...
>
> Please wait a bit, I need to recheck.

Yes, mlock looks buggy. I'll report more info a bit later, but
I think we need something like this patch.

Oleg.

