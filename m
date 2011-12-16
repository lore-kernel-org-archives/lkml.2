Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab1LPCKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:10:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab1LPCKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:10:52 -0500
Message-ID: <4EEAA923.5060104@cn.fujitsu.com>
Date: Fri, 16 Dec 2011 10:12:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] cgroups: fix a css_set not found bug in cgroup_attach_proc
References: <1323977803-5385-1-git-send-email-msb@chromium.org> <20111215212329.GH32002@google.com>
In-Reply-To: <20111215212329.GH32002@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-16 10:10:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-16 10:10:13,
	Serialize complete at 2011-12-16 10:10:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On Thu, Dec 15, 2011 at 11:36:43AM -0800, Mandeep Singh Baines wrote:
>> There is a BUG when migrating a PF_EXITING proc. Since css_set_prefetch()
>> is not called for the PF_EXITING case, find_existing_css_set() will return
>> NULL inside cgroup_task_migrate() causing a BUG.
>>
>> This bug is easy to reproduce. Create a zombie and echo its pid to
>> cgroup.procs.
>>
>> $ cat zombie.c
>> \#include <unistd.h>
>>
>> int main()
>> {
>>   if (fork())
>>       pause();
>>   return 0;
>> }
>> $
>>
>> We are hitting this bug pretty regularly on ChromeOS.
>>
>> This bug is already fixed by Tejun Heo's cgroup patchset which is
>> targetted for the next merge window:
>>
>> https://lkml.org/lkml/2011/11/1/356
>>
>> I've create a smaller patch here which just fixes this bug so that a
>> fix can be merged into the current release and stable.
> 
> Looks safe to me.  Li?
> 

It should be fine.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
