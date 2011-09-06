Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1IFP3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab1IFP3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:29:11 -0400
Date: Tue, 6 Sep 2011 17:25:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110906152539.GA16899@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org> <1314988070-12244-7-git-send-email-tj@kernel.org> <20110904184626.GA30101@redhat.com> <20110905023315.GB9807@htj.dyndns.org> <20110905162012.GA4445@redhat.com> <20110906032846.GA18425@mtj.dyndns.org> <20110906151836.GA15568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906151836.GA15568@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06, Oleg Nesterov wrote:
>
> Yes, agreed. In this case I think it should be
>
> 	#define wait_event_freezable(wq, condition)				\
> 	({									\
> 		int __retval;							\
> 		for (;;) {							\
> 			__retval = wait_event_interruptible(wq, 		\
> 					(condition) || freezing(current));	\
> 			if (__retval || (condition))				\
> 				break;						\
> 			try_to_freeze();					\
> 		}								\
> 		__retval;							\
> 	})
>
> __retval/ERESTARTSYS is only needed for kthreads which play with allow_signal(),
> probably nobody should do this.

I meant, unless the caller plays with allow_signal(), it has all rights to do

	if (wait_event_freezable(...))
		BUG();

This becomes correct with the code above.

Oleg.

