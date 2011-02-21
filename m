Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab1BUF3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:29:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53142 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1BUF3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:29:06 -0500
Message-ID: <4D61F876.3040401@cn.fujitsu.com>
Date: Mon, 21 Feb 2011 13:30:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7ED1.2070601@cn.fujitsu.com> <alpine.DEB.2.00.1102191745180.27722@chino.kir.corp.google.com> <4D61DA04.4060007@cn.fujitsu.com>
In-Reply-To: <4D61DA04.4060007@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 13:27:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 13:27:58,
	Serialize complete at 2011-02-21 13:27:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Calling cpuset_static_nodemask() should be paired with this function,
> + * so we insure the global nodemask won't be used by more than one user
> + * at the one time.
> + */
> +static void cpuset_release_static_nodemask(void)
> +{
> +	WARN_ON(!cgroup_lock_is_held());
> +
> +	cpuset_mems_ref--;
> +	WARN_ON(!cpuset_mems_ref);

WARN_ON(cpuset_mems_ref);

> +}
