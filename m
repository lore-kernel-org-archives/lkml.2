Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1L0Bba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 20:31:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60662 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab1L0BbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 20:31:24 -0500
Message-ID: <4EF9206F.3090207@cn.fujitsu.com>
Date: Tue, 27 Dec 2011 09:33:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v2] cgroup: Remove task_lock() from cgroup_post_fork()
References: <1324610723-30080-1-git-send-email-fweisbec@gmail.com> <20111223230013.GV17084@google.com>
In-Reply-To: <20111223230013.GV17084@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 09:30:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 09:30:34,
	Serialize complete at 2011-12-27 09:30:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On Fri, Dec 23, 2011 at 04:25:23AM +0100, Frederic Weisbecker wrote:
>> cgroup_post_fork() is protected between threadgroup_change_begin()
>> and threadgroup_change_end() against concurrent changes of the
>> child's css_set in cgroup_task_migrate(). Also the child can't
>> exit and call cgroup_exit() at this stage, this means it's css_set
>> can't be changed with init_css_set concurrently.
>>
>> For these reasons, we don't need to hold task_lock() on the child
>> because it's css_set can only remain stable in this place.
>>
>> Let's remove the lock there.
>>
>> v2: Update comment to explain that we are safe against
>> cgroup_exit()
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Li Zefan <lizf@cn.fujitsu.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Containers <containers@lists.linux-foundation.org>
>> Cc: Cgroups <cgroups@vger.kernel.org>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Paul Menage <paul@paulmenage.org>
>> Cc: Mandeep Singh Baines <msb@chromium.org>
> 
> Li, does this look good to you?
> 

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
