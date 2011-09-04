Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1IDSXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:23:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1IDSXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:23:37 -0400
Date: Sun, 4 Sep 2011 20:20:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] cgroup_freezer: fix freezer->state setting bug in
	freezer_change_state()
Message-ID: <20110904182019.GA29525@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org> <1314988070-12244-2-git-send-email-tj@kernel.org> <20110904180206.GA28520@redhat.com> <20110904181139.GA9807@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904181139.GA9807@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05, Tejun Heo wrote:
>
> On Sun, Sep 04, 2011 at 08:02:06PM +0200, Oleg Nesterov wrote:
> > Cough. Now it doesn't look right to me ;)
> >
> > If the user write "FROZEN" into the control file, we should not
> > turn the CGROUP_FROZEN state into CGROUP_FREEZING. Probably this
> > is harmless, but this looks wrong and this doesn't match the
> > current behaviour, user-visible change.
>
> It's not user-visible as the state is always updated before shown to
> userland.

Ah, indeed, thanks.

OK.

So, the only proble I can see is that update_if_frozen() can hit
BUG_ON(nfrozen > 0), but this is off-topic.

I think this patch is correct.

Oleg.

