Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0IIWJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0IIWJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:09:37 -0400
Date: Fri, 10 Sep 2010 00:05:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net>, Eugene Teo" 
	<eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] oom: don't ignore rss in nascent mm
Message-ID: <20100909220504.GA6273@redhat.com>
References: <20100908023417.8B055401AF@magilla.sf.frob.com> <20100909134842.C93F.A69D9226@jp.fujitsu.com> <20100909140219.C942.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909140219.C942.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, KOSAKI Motohiro wrote:
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1226,6 +1226,7 @@ struct task_struct {
>  	int pdeath_signal;  /*  The signal sent when the parent dies  */
>  	/* ??? */
>  	unsigned int personality;
> +	struct mm_struct *in_exec_mm;

Oh, yes, this has to be per-thread (unlike ->mm, btw).

I wonder if it makes sense to move ->cred_guard_mutex from task_struct
to signal_struct and thus make multiple-threads-inside-exec impossible.
Only one thread can win anyway.

Oleg.

