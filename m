Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1LNC1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:27:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61613 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab1LNC1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:27:32 -0500
Message-ID: <4EE80A0D.7090808@cn.fujitsu.com>
Date: Wed, 14 Dec 2011 10:29:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, cgroups@vger.kernel.org,
        bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/3] make clone_children a flag
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com> <20111213153921.GE25802@google.com>
In-Reply-To: <20111213153921.GE25802@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-14 10:26:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-14 10:26:52,
	Serialize complete at 2011-12-14 10:26:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On Sun, Dec 11, 2011 at 03:45:37PM +0100, Glauber Costa wrote:
>> There is no reason to have a flags field, and then a separate
>> bool field just to indicate if the clone_children flag is set.
>> Make it a flag
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
> 
> Doesn't this change how remount conditions are checked?
> 

Right. Currently we can do this:

	# mount -t cgroup xxx /mnt
	# mount -o remount,clone_children /mnt

with this patch, the above remount will fail.

But..the current bevaiour of remount is a bit confusing in that remount
with/without "clone_children" has no effect on anything:

	# mount -t cgroup -o clone_children xxx /mnt
	# cat /mnt/cgroup.clone_children
	1
	# mount -o remount xxx /mnt
	# mount | grep cgroup
	xxx on /mnt type cgroup (rw,clone_children)
	# cat /mnt/cgroup.clone_children
	1
