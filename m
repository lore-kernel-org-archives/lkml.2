Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1IDSLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:11:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42465 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1IDSLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:11:47 -0400
Date: Mon, 5 Sep 2011 03:11:39 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] cgroup_freezer: fix freezer->state setting bug in
 freezer_change_state()
Message-ID: <20110904181139.GA9807@htj.dyndns.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
 <1314988070-12244-2-git-send-email-tj@kernel.org>
 <20110904180206.GA28520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904180206.GA28520@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 08:02:06PM +0200, Oleg Nesterov wrote:
> Cough. Now it doesn't look right to me ;)
> 
> If the user write "FROZEN" into the control file, we should not
> turn the CGROUP_FROZEN state into CGROUP_FREEZING. Probably this
> is harmless, but this looks wrong and this doesn't match the
> current behaviour, user-visible change.

It's not user-visible as the state is always updated before shown to
userland.  If we're gonna be re-priming freezing on each FROZEN write,
resetting the state to freezing to force state re-calculation is
logical thing to do.

Thanks.

-- 
tejun
