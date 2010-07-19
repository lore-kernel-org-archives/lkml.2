Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966799Ab0GSVEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966763Ab0GSVEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:04:44 -0400
Date: Mon, 19 Jul 2010 17:04:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@kernel.dk, nauman@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [PATCH 2/3] cfq-iosched: Implement a new tunable group_idle
Message-ID: <20100719210434.GG32503@redhat.com>
References: <1279559652-2775-1-git-send-email-vgoyal@redhat.com>
 <1279559652-2775-3-git-send-email-vgoyal@redhat.com>
 <AANLkTil2A2y5f1jrMlAwN3r33TPsVBY3_NHTRlcbmX0F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil2A2y5f1jrMlAwN3r33TPsVBY3_NHTRlcbmX0F@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 01:54:53PM -0700, Divyesh Shah wrote:
> On Mon, Jul 19, 2010 at 10:14 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > @@ -3420,7 +3453,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
> >                 * the queue.
> >                 */
> >                if (cfq_should_wait_busy(cfqd, cfqq)) {
> > -                       cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
> > +                       unsigned long extend_sl = cfqd->cfq_slice_idle;
> > +                       if (!cfqd->cfq_slice_idle)
> > +                               extend_sl = cfqd->cfq_group_idle;
> > +                       cfqq->slice_end = jiffies + extend_sl;
> >                        cfq_mark_cfqq_wait_busy(cfqq);
> >                        cfq_log_cfqq(cfqd, cfqq, "will busy wait");
> >                }
> 
> Vivek, I haven't looked at this particular code snippet for some time.
> Can you tell me why we add the slice_idle (or w/ your change
> extend_sl) to slice_end instead of arming the idle timer with that
> amount of time?

Divyesh,

With wait busy we do arm the slice time also. wait busy is just saying
that extend the slice a bit so that we do arm the timer and select_queue()
does not expire the queue right away.

Vivek
