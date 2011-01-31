Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1AaJlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 04:41:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38671 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab1AaJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 04:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gOtT+UG2gmgbvve+856Gwsfja/ZyB3nzsdbsNeMA1QhbjNTAPIG9MwiRNACc561vR+
         XqAtA7Juv0oapzykU7P9CXFggmi0MBHZVB4H1TBLc9MgGOJz2AkC3BsW9TkO+eg3zPJq
         w+95JjO72EN/WWW5f0Ngp71xMgQblyqhdOC/o=
Message-ID: <4D4683A9.8050400@suse.cz>
Date: Mon, 31 Jan 2011 10:40:57 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kacper Kornet <kornet@camk.edu.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [for .36,.37 stable] Re: [PATCH v2] Fix prlimit64 for suid/sgid processes
References: <20110127134710.GB519@camk.edu.pl> <AANLkTimOM7KDtFkU=CmXZ8J2FqekY=EjCuOdtZHQJQWT@mail.gmail.com> <20110128232104.GA22667@camk.edu.pl>
In-Reply-To: <20110128232104.GA22667@camk.edu.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing stable.

Merged as aa5bd67dcfdf9 and should go into:
->.36-stable (if maintained still)
->.37-stable

On 01/29/2011 12:21 AM, Kacper Kornet wrote:
> Since check_prlimit_permission always fails in the case of SUID/GUID
> processes, such processes are not able to read or set their own limits.
> This commit changes this by assuming that process can always read/change
> its own limits.
> 
> Signed-off-by: Kacper Kornet <kornet@camk.edu.pl>
> ---
>  kernel/sys.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index e9ad444..03bead7 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1375,7 +1375,8 @@ static int check_prlimit_permission(struct task_struct *task)
>  	const struct cred *cred = current_cred(), *tcred;
>  
>  	tcred = __task_cred(task);
> -	if ((cred->uid != tcred->euid ||
> +	if (current != task &&
> +	    (cred->uid != tcred->euid ||
>  	     cred->uid != tcred->suid ||
>  	     cred->uid != tcred->uid  ||
>  	     cred->gid != tcred->egid ||

thanks,
-- 
js
suse labs
