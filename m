Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab1DHSZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:25:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1DHSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cAsR5Kew0JKtf6WxUJPDjR1gUDELwva+hXTySRSIyRBVUEWcDCesrgvDeSVnjE38py
         sdX0FZxqneYUle+5E+9Q==
MIME-Version: 1.0
In-Reply-To: <870910A1-62AF-412F-A989-1FA57B715E35@parallels.com>
References: <20110408002420.3F3A912217F@elm.corp.google.com>
	<870910A1-62AF-412F-A989-1FA57B715E35@parallels.com>
Date: Fri, 8 Apr 2011 11:25:28 -0700
Message-ID: <BANLkTinWBdURcb2+P5YC99audiVohX4DQA@mail.gmail.com>
Subject: Re: Subject: [PATCH] sched: fixed erroneous all_pinned logic.
From: Ken Chen <kenchen@google.com>
To: Vladimir Davydov <VDavydov@parallels.com>
Cc: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 3:57 AM, Vladimir Davydov wrote:
>
> As far as I understand, this patch sets the all_pinned flag if
> and only if we fail to move any tasks during the load balance.
> However, the migration can fail because e.g. all tasks are
> cache hot on their cpus (can_migrate_task() returns 0 in this
> case), and in this case we shouldn't treat all tasks as cpu
> bound, should we?

all_pinned logic is not restricted for tasks that have hard CPU affinity.
In balance_tasks(), e.g. if all tasks have high weight, it would also trip
all_pinned to 1.  See ( p->se.load.weight >> 1) > rem_load_move).  I don't
see much difference whether a task has high weight, or is cache hot, or
has hard cpu affinity.

The effect of classifying cache_hot as pinned task or not is difficult to
measure, I think.  Because that state is more temporal compare to the
other two conditions.

I don't have enough data to indicate which way is better though.

- Ken
