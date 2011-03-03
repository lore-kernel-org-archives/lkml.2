Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab1CCHfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:35:52 -0500
Received: from www.tglx.de ([62.245.132.106]:40157 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1CCHfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:35:50 -0500
Date: Thu, 3 Mar 2011 08:34:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Li Zefan <lizf@cn.fujitsu.com>
cc: "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
In-Reply-To: <4D6F3C5B.8020307@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1103030829310.2701@localhost6.localdomain6>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name> <1299084001-3916-2-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6> <4D6F3C5B.8020307@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011, Li Zefan wrote:

> >> +unsigned long get_task_timer_slack(struct task_struct *tsk)
> >> +{
> >> +	struct cgroup_subsys_state *css;
> >> +	struct tslack_cgroup *tslack_cgroup;
> >> +	unsigned long ret;
> >> +
> >> +	rcu_read_lock();
> > 
> > Did you just remove the odd comment or actually figure out why you
> > need rcu_read_lock() here ?
> > 
> 
> It's necessary to protect against task exiting or task moving between cgroups.

I know, though after the last review I wanted to make sure, that the
author understands it as well and not just removed the odd comment
just because I ranted about it :)

Thanks,

	tglx
