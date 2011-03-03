Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1CCG5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:57:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50705 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab1CCG5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:57:32 -0500
Message-ID: <4D6F3C5B.8020307@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 14:59:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name> <1299084001-3916-2-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:56:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:56:21,
	Serialize complete at 2011-03-03 14:56:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +unsigned long get_task_timer_slack(struct task_struct *tsk)
>> +{
>> +	struct cgroup_subsys_state *css;
>> +	struct tslack_cgroup *tslack_cgroup;
>> +	unsigned long ret;
>> +
>> +	rcu_read_lock();
> 
> Did you just remove the odd comment or actually figure out why you
> need rcu_read_lock() here ?
> 

It's necessary to protect against task exiting or task moving between cgroups.

>> +	css = task_subsys_state(tsk, timer_slack_subsys.subsys_id);
>> +	tslack_cgroup = container_of(css, struct tslack_cgroup, css);
>> +	ret = max(tsk->timer_slack_ns, tslack_cgroup->min_slack_ns);
>> +	rcu_read_unlock();
>> +
>> +	return ret;
>> +}
> 
> Otherwise, it's way more palatable than the last one.
> 
> Thanks,
> 
> 	tglx
> 
