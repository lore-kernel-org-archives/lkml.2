Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2KUCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:25:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51741 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2KUCZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:25:57 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242725"
Message-ID: <50AC3BA7.3090100@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:25:43 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/11] pidns: Deny strange cases when creating pid namespaces.
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-8-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-8-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:25:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:25:40,
	Serialize complete at 2012/11/21 10:25:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2012/11/17 00:35, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> task_active_pid_ns(current) != current->ns_proxy->pid_ns will
> soon be allowed to support unshare and setns.
> 
> The definition of creating a child pid namespace when
> task_active_pid_ns(current) != current->ns_proxy->pid_ns could be that
> we create a child pid namespace of current->ns_proxy->pid_ns.  However
> that leads to strange cases like trying to have a single process be
> init in multiple pid namespaces, which is racy and hard to think
> about.
> 
> The definition of creating a child pid namespace when
> task_active_pid_ns(current) != current->ns_proxy->pid_ns could be that
> we create a child pid namespace of task_active_pid_ns(current).  While
> that seems less racy it does not provide any utility.
> 
> Therefore define the semantics of creating a child pid namespace when
> task_active_pid_ns(current) != current->ns_proxy->pid_ns to be that the
> pid namespace creation fails.  That is easy to implement and easy
> to think about.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
