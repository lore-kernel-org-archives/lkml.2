Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1IFPxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:53:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55200 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab1IFPxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:53:42 -0400
Date: Wed, 7 Sep 2011 00:53:32 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110906155332.GF18425@mtj.dyndns.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
 <1314988070-12244-7-git-send-email-tj@kernel.org>
 <20110904184626.GA30101@redhat.com>
 <20110905023315.GB9807@htj.dyndns.org>
 <20110905162012.GA4445@redhat.com>
 <20110906032846.GA18425@mtj.dyndns.org>
 <20110906151836.GA15568@redhat.com>
 <20110906152539.GA16899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906152539.GA16899@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 06, 2011 at 05:25:39PM +0200, Oleg Nesterov wrote:
> On 09/06, Oleg Nesterov wrote:
> >
> > Yes, agreed. In this case I think it should be
> >
> > 	#define wait_event_freezable(wq, condition)				\
> > 	({									\
> > 		int __retval;							\
> > 		for (;;) {							\
> > 			__retval = wait_event_interruptible(wq, 		\
> > 					(condition) || freezing(current));	\
> > 			if (__retval || (condition))				\
> > 				break;						\
> > 			try_to_freeze();					\
> > 		}								\
> > 		__retval;							\
> > 	})
> >
> > __retval/ERESTARTSYS is only needed for kthreads which play with allow_signal(),
> > probably nobody should do this.
> 
> I meant, unless the caller plays with allow_signal(), it has all rights to do
> 
> 	if (wait_event_freezable(...))
> 		BUG();
> 
> This becomes correct with the code above.

Yeap, sure, w/ freezable_with_signal gone, the above should work fine.
Care to create a patch?

Thanks.

-- 
tejun
