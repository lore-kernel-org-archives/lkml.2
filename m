Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1L1GI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 01:08:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54897 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1L1GI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 01:08:27 -0500
Message-ID: <4EFAB2E2.4040008@cn.fujitsu.com>
Date: Wed, 28 Dec 2011 14:10:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
References: <4EF9291D.7030208@cn.fujitsu.com> <20111227163535.GA17712@google.com>
In-Reply-To: <20111227163535.GA17712@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-28 14:07:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-28 14:07:37,
	Serialize complete at 2011-12-28 14:07:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Dec 27, 2011 at 10:10:37AM +0800, Li Zefan wrote:
>> If we mount a hierarchy with a name specified, the name is unique,
>> and we can use it to mount the hierarchy without specifying its
>> set of subsystem names. This feature is documented is
>> Documentation/cgroups/cgroups.txt section 2.3
>>
>> Here's an example:
>>
>> 	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
>> 	# mount -t cgroup -o name=myhier xxx /cgroup2
>>
>> But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
>> (cgroup: make the mount options parsing more accurate)
>>
>> This fixes the regression.
> 
> Hmmm... so that has been broken over a year and nobody complained?  Is
> there any valid use case where specifying mount path as all other
> filesystems wouldn't work?  Is this 'name' thing necessary at all?
> Maybe we should rip it out instead of fixing it?  We can just leave it
> as non-functional name which does nothing but being visible in mount
> listing.
> 

The "name" option was introduced along with the "none" option, so we
can distinguish between different cgroup hierarchies which have no
bound subsystems, like this:

	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
	# mount -t cgroup -o none,name=hier2 xxx /cgroup2

As the name is unique, we have this "mount by hierarchy name" feature.
It looks reasonable, but I guess few people know this feature. We can
live with it, as it only saves us some typing when mounting an existing
hierarchy. On the other hand, removing this small feature can hardly
result in code reduction.
