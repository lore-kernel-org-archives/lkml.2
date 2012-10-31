Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2JaRKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:10:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46423 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2JaRKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <50915A87.4070504@parallels.com>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<1351657365-25055-3-git-send-email-tj@kernel.org>
	<20121031153926.GC22809@dhcp22.suse.cz>
	<20121031165739.GE2945@htj.dyndns.org>
	<50915A87.4070504@parallels.com>
Date: Wed, 31 Oct 2012 10:10:44 -0700
X-Google-Sender-Auth: f_1ksL48sD05NsitZqMMcQKAJR0
Message-ID: <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com>
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, lizefan@huawei.com, hannes@cmpxchg.org,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Oct 31, 2012 at 10:06 AM, Glauber Costa <glommer@parallels.com> wrote:
> This is not the topic of this thread, but since you brought it:
> If you take a look at the description patch in the patch I sent, the
> problem I outlined is that at create time, we don't know anything about
> which will the css_id be - and I would like to avoid creating yet
> another index.
>
> Is there any way you would suggest of handling this ? Any chance of us
> allocating the css_id earlier then?

I only glanced the patch description but the problem I'm trying to
solve is locking - currently we don't have a place where a controller
can tell a cgroup is becoming online; thus it has nothing to
synchronized against and tell that a cgroup is alive or not.  As for
css_id allocation, maybe you can deal with that in ->post_create() or
maybe we can allocate css_id earlier (but where would it be stored?).
I'll look into it.

Thanks.

-- 
tejun
