Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297Ab1IKSoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 14:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab1IKSoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 14:44:38 -0400
Date: Sun, 11 Sep 2011 20:41:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, matthltc@us.ibm.com,
        paul@paulmenage.org, containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] freezer: fix wait_event_freezable/__thaw_task races
Message-ID: <20110911184107.GA23918@redhat.com>
References: <20110906032846.GA18425@mtj.dyndns.org> <20110906151836.GA15568@redhat.com> <20110906152539.GA16899@redhat.com> <20110906155332.GF18425@mtj.dyndns.org> <20110907182156.GA13909@redhat.com> <20110907182217.GB13909@redhat.com> <20110908010530.GD3987@mtj.dyndns.org> <20110908175926.GA26986@redhat.com> <20110911015431.GK29319@htj.dyndns.org> <20110911182953.GA22941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911182953.GA22941@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11, Oleg Nesterov wrote:
>
> On 09/11, Tejun Heo wrote:
> >
> > On Thu, Sep 08, 2011 at 07:59:26PM +0200, Oleg Nesterov wrote:
> >
> > > > Yeap, with freezable_with_signal gone, this looks correct & simpler to
> > > > me
> > >
> > > I don't really understand this... set_freezable_with_signal() has a
> > > lot of problems, yes... But even if it wasn't removed this fix makes
> > > sense anyway, afaics.
> > >
> > > If freezable_with_signal caller does wait_event_freezable_timeout(),
> > > __retval becomes -ERESTARTSYS after freeze_task(). The next iteration
> > > will return 0 with the KERN_ERR message from schedule_timeout().
> >
> > Hmmm... but with the change, if a kthread gets TIF_SIGPENDING from
> > freezer and then thawed, it would not enter try_to_freeze() and thus
> > won't clear TIF_SIGPENDING.
>
> Ah yes, you are right, thanks. But once again, please note that in this
> case wait_event_freezable_timeout() is broken anyway.

OTOH, I forgot about wait_event_freezable(). It was racy, but mostly
worked. So yes, you are right, without "kill freezable_with_signal"
this patch is wrong.

I missed this, thanks.

Oleg.

