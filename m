Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1IGS05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:26:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab1IGS04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:26:56 -0400
Date: Wed, 7 Sep 2011 20:21:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: matthltc@us.ibm.com, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20110907182156.GA13909@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org> <1314988070-12244-7-git-send-email-tj@kernel.org> <20110904184626.GA30101@redhat.com> <20110905023315.GB9807@htj.dyndns.org> <20110905162012.GA4445@redhat.com> <20110906032846.GA18425@mtj.dyndns.org> <20110906151836.GA15568@redhat.com> <20110906152539.GA16899@redhat.com> <20110906155332.GF18425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906155332.GF18425@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/07, Tejun Heo wrote:
> >
> > I meant, unless the caller plays with allow_signal(), it has all rights to do
> >
> > 	if (wait_event_freezable(...))
> > 		BUG();
> >
> > This becomes correct with the code above.
>
> Yeap, sure, w/ freezable_with_signal gone, the above should work fine.
> Care to create a patch?

Sure.

But. Tejun, Rafael, I have to rely on your review. I have no idea how
can I test this change. Hopfully it is simple enough, though.

And. wait_event_freezable_timeout() obviously has another problem,
although I hope this is fine. The caller can spend a lot of time in
refrigerator, shouldn't we update "timeout" in this case? I hope we
shouldn't.

Oleg.

