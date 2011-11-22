Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1KVCSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:18:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64301 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab1KVCSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:18:16 -0500
Message-ID: <4ECB06D2.6060106@cn.fujitsu.com>
Date: Tue, 22 Nov 2011 10:20:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz> <20111121230709.GR25776@google.com>
In-Reply-To: <20111121230709.GR25776@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-22 10:17:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-22 10:17:57,
	Serialize complete at 2011-11-22 10:17:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Nov 16, 2011 at 10:50:34PM +0100, Michal Hocko wrote:
>> +/* Task is frozen or will freeze immediately when next it gets woken */
>> +static bool is_task_frozen_enough(struct task_struct *task)
>> +{
>> +	return frozen(task) ||
>> +		(task_is_stopped_or_traced(task) && freezing(task));
>> +}
> 
> Hmmm... w/ pending freezer updates, the above would always return
> %true if there's freezing in progress, which can't be right.  Maybe

Only if the task is stopped/trace.

If we try to freeze a stopped task, it will be kept in freezing state.

> just test stopped/traced?
> 

This can trigger a BUG_ON in update_if_frozen(), because we always count a
stopped task as frozen.

>   http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=refs/heads/pm-freezer
> 
> Thanks.
> 
