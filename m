Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1L2Crx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 21:47:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1L2Crv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 21:47:51 -0500
Message-ID: <4EFBD55E.5030106@cn.fujitsu.com>
Date: Thu, 29 Dec 2011 10:50:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
References: <4EF9291D.7030208@cn.fujitsu.com> <20111227163535.GA17712@google.com> <4EFAB2E2.4040008@cn.fujitsu.com> <20111228163631.GN17712@google.com>
In-Reply-To: <20111228163631.GN17712@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 10:47:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-29 10:47:02,
	Serialize complete at 2011-12-29 10:47:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Dec 28, 2011 at 02:10:42PM +0800, Li Zefan wrote:
>> The "name" option was introduced along with the "none" option, so we
>> can distinguish between different cgroup hierarchies which have no
>> bound subsystems, like this:
>>
>> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
>> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
>>
>> As the name is unique, we have this "mount by hierarchy name" feature.
> 
> I could be missing something but does that add anything other than
> naming convenience?
> 

The name option is necessary, otherwise how can we mount hierarchies
as shown in the above example?

>> It looks reasonable, but I guess few people know this feature. We can
>> live with it, as it only saves us some typing when mounting an existing
>> hierarchy. On the other hand, removing this small feature can hardly
>> result in code reduction.
> 
> If it's a redundant feature which has been broken over a year without
> anyone complaining, it really doesn't need to exist.  It might not
> save a lot of code but would save some WTH moments.
> 

The redundant feature is mouting existing hierarchies by specifying name
only, and the cleanup patch I sent has this feature removed in effect.

kernel/cgroup.c |   15 +++++++--------
1 files changed, 7 insertions(+), 8 deletions(-)

This is why I'm not so keen to remove the feature.
