Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0LAE4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 23:56:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54850 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab0LAE4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 23:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sf/zO6ppQKsqUechisJhCyR92NWISXVVII8Mo/LhycB4pMIkYFhxT2bbNzlA2soCmW
         ncKYTx+RfA8l29phLXtLdz7sPA1Acs1ODg7IKXmPV45+DFQpmYWY/MyYKjAMsY24yoge
         TMjQkG6X6W8OlmZgCNe94cTLqLi72NbN8Oquk=
Date: Wed, 1 Dec 2010 13:01:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101201050129.GA5210@cr0.nay.redhat.com>
References: <1291052268.32004.171.camel@laptop>
 <1291057565.20709.2.camel@marge.simson.net>
 <20101129192033.GA18372@elte.hu>
 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
 <1291090455.7550.7.camel@marge.simson.net>
 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
 <1291123083.28239.18.camel@marge.simson.net>
 <20101130151749.GE26758@redhat.com>
 <1291137221.28239.70.camel@marge.simson.net>
 <20101130193622.GF26758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130193622.GF26758@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 02:36:22PM -0500, Vivek Goyal wrote:
>
>So again, user will think that task is in cgroup test1 and is being
>controlled by the respective weight but that's not the case.
>
>Even if we prevent autogroup task from being visible in cpu controller
>root group, then comes the question what happens if cpu and some other
>controller is comounted. Say cpuset. Now in that case will task be 
>visible in root group task file and can one operate on that. Now showing
>up there does not make much sense as task should still be controllable
>by other controllers and its policies.
>
>So yes, creating a /proc/<pid>/autogroup is dirt cheap and makes the life
>easier in terms of implementation of this patch and it should work well.
>But it is also a new user interface which does not sound too extensible and
>does not seem to cooperate well with cgroup interface.
>
>It also introduces this new notion of niceness for task groups which is sort
>of equivalent to cpu.shares in cpu controller. First of all why should we
>not stick to shares notion even for autogroup. Even if we introduce the notion
>of niceness for groups, IMHO, it should be through cgroup interface instead of
>group niceness for autogroup and shares/weights for cgroup despite the
>fact that in the background they do similar things.
>

Hmm, maybe we can make AUTO_GROUP depend on !CGROUPS?

It seems that autogroup only uses 'struct task_group', no other cgroup things,
so I think that is reasonable and doable.
