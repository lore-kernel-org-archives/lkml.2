Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab2JaRZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:25:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36615 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab2JaRZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:25:27 -0400
Date: Wed, 31 Oct 2012 10:25:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, lizefan@huawei.com, hannes@cmpxchg.org,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
Message-ID: <20121031172522.GJ2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-3-git-send-email-tj@kernel.org>
 <20121031153926.GC22809@dhcp22.suse.cz>
 <20121031165739.GE2945@htj.dyndns.org>
 <50915A87.4070504@parallels.com>
 <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com>
 <50915DB7.5020706@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50915DB7.5020706@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 31, 2012 at 09:19:51PM +0400, Glauber Costa wrote:
> I don't see post_create failing as a huge problem. The natural
> synchronization point would be "right after post_create" - then you can
> definitely tell that it is online. Although this can be viewed a bit as
> "exposing internals", creating is different then destroying: When you
> create, you may not have all data yet. When destroying, you do - and
> want to get rid of it. So this kind of bootstrapping is pretty standard
> and common.

More proper names for these callbacks would be,

	->allocate()
	->online()
	->offline()
	->free()

And I may rename them.  I don't wanna make ->online() failable.  Why
can't you just allocate everything from ->allocate() and use it from
->online()?

Thanks.

-- 
tejun
