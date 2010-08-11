Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0HKNRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:17:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39958 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab0HKNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:17:19 -0400
Message-ID: <4C62A2DA.2030201@canonical.com>
Date: Wed, 11 Aug 2010 09:17:14 -0400
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/1] AppArmor: fix task_setrlimit prototype
References: <1281518882-4130-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1281518882-4130-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 05:28 AM, Jiri Slaby wrote:
> After rlimits tree was merged we get the following errors:
> security/apparmor/lsm.c:663:2: warning: initialization from incompatible pointer type
> 
> It is because AppArmor was merged in the meantime, but uses the old
> prototype. So fix it by adding struct task_struct as a first parameter
> of apparmor_task_setrlimit.
> 
> NOTE that this is ONLY a compilation warning fix (and crashes caused
> by that). It needs proper handling in AppArmor depending on who is the
> 'task'.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: John Johansen <john.johansen@canonical.com>
> Cc: James Morris <jmorris@namei.org>
> ---
>  security/apparmor/lsm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 8db33a8..06f4d02 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -607,8 +607,8 @@ static int apparmor_setprocattr(struct task_struct *task, char *name,
>  	return error;
>  }
>  
> -static int apparmor_task_setrlimit(unsigned int resource,
> -				   struct rlimit *new_rlim)
> +static int apparmor_task_setrlimit(struct task_struct *task,
> +		unsigned int resource, struct rlimit *new_rlim)
>  {
>  	struct aa_profile *profile = aa_current_profile();
>  	int error = 0;

thanks Jiri, I'll get an update for apparmor handling task part out today.

Signed-off-by: John Johansen <john.johansen@canonical.com>

