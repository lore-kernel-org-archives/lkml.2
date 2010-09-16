Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0IPTjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:39:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0IPTjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:39:46 -0400
Date: Thu, 16 Sep 2010 21:35:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fs/exec.c: provide the correct process pid to the
	pipe helper
Message-ID: <20100916193543.GA11016@redhat.com>
References: <1284663599-3549-1-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284663599-3549-1-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16, Will Drewry wrote:
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1467,6 +1467,13 @@ static int format_corename(char *corename, long signr)
>  	char *const out_end = corename + CORENAME_MAX_SIZE;
>  	int rc;
>  	int pid_in_pattern = 0;
> +	pid_t pid = task_tgid_vnr(current);
> +
> +	/* The pipe helper runs in the init namespace and should
> +	 * receive the matching pid until that changes.
> +	 */
> +	if (ispipe)
> +		pid = task_tgid_nr(current);

Agreed, it doesn't make sense to pass the "local" pid to the init ns.

Oleg.

