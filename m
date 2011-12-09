Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1LIAuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:50:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38386 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1LIAuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:50:07 -0500
Message-ID: <4EE15B39.9050302@canonical.com>
Date: Thu, 08 Dec 2011 16:50:01 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] apparmor: add missing rcu_dereference()
References: <20111209002548.GA30520@www.outflux.net>
In-Reply-To: <20111209002548.GA30520@www.outflux.net>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 04:25 PM, Kees Cook wrote:
> Adds a missed rcu_dereference() around real_parent.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  security/apparmor/audit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
> index 96502b2..f3fafed 100644
> --- a/security/apparmor/audit.c
> +++ b/security/apparmor/audit.c
> @@ -133,7 +133,7 @@ static void audit_pre(struct audit_buffer *ab, void *ca)
>  		struct aa_profile *profile = sa->aad.profile;
>  		pid_t pid;
>  		rcu_read_lock();
> -		pid = tsk->real_parent->pid;
> +		pid = rcu_dereference(tsk->real_parent)->pid;
>  		rcu_read_unlock();
>  		audit_log_format(ab, " parent=%d", pid);
>  		if (profile->ns != root_ns) {
yep.

Acked-by: John Johansen <john.johansen@canonical.com>

