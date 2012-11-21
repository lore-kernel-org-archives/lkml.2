Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2KUCCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:02:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab2KUCC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:02:28 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242461"
Message-ID: <50AC362B.9040606@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:02:19 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/11] pidns: Use task_active_pid_ns where appropriate
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-4-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-4-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:02:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:02:10,
	Serialize complete at 2012/11/21 10:02:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2012/11/17 00:35, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> The expressions tsk->nsproxy->pid_ns and task_active_pid_ns
> aka ns_of_pid(task_pid(tsk)) should have the same number of
> cache line misses with the practical difference that
> ns_of_pid(task_pid(tsk)) is released later in a processes life.
> 
> Furthermore by using task_active_pid_ns it becomes trivial
> to write an unshare implementation for the the pid namespace.
> 
> So I have used task_active_pid_ns everywhere I can.
> 
> In fork since the pid has not yet been attached to the
> process I use ns_of_pid, to achieve the same effect.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

