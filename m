Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1KFQvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:51:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58090 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1KFQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:51:19 -0500
Date: Sun, 6 Nov 2011 08:51:12 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arnd@arndb.de, oleg@redhat.com,
        matthltc@us.ibm.com, Paul Menage <menage@google.com>
Subject: Re: [PATCH 05/17] freezer: rename thaw_process() to __thaw_task()
 and simplify the implementation
Message-ID: <20111106165112.GB13699@google.com>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
 <1320087928-32307-6-git-send-email-tj@kernel.org>
 <4EB677CB.20608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB677CB.20608@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Nov 06, 2011 at 05:34:27PM +0530, Srivatsa S. Bhat wrote:
> On 11/01/2011 12:35 AM, Tejun Heo wrote:
> >   * task_lock() is needed to prevent the race with refrigerator() which may
>                                                      ^^^^^^
>                                                 __refrigerator()?

I don't think this really matters.  Maybe just drop () from the
comment?

> Rebasing to latest kernel, we need to do the conversion in mm/oom_kill.c as well,
> (and consequently add __thaw_task() empty function under !CONFIG_FREEZER, in
> include/linux/freezer.h)

Yes, for merging, we should do that, but for longer term, as we can
modify freezing condition with relative ease now, I think we should
make tasks being killed ignore freezer instead of relying on
explicitly calling __thaw_task() which is inherently racy.

Thank you.

-- 
tejun
