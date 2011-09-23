Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab1IWRk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1IWRk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:40:56 -0400
Date: Fri, 23 Sep 2011 19:36:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110923173656.GA5233@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920174849.GB22317@redhat.com> <20110920185354.GA19629@sergelap> <20110921175357.GA25590@redhat.com> <20110923163113.GA3820@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110923163113.GA3820@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Serge E. Hallyn wrote:
>
> It looks like I can fix all the
> cases

except ptrace_signal(). Although we can simply ignore this case, imho.

> at send_signal()

Yes, I was thinking about this too but didn't have the time to check
if this can really work.

> by checking whether si_fromuser(info)

I am not sure... sys_rt_queueinfo() is nasty. Plus we have to handle
the "fromkernel" case too. May be we can ignore this too.

Oleg.

