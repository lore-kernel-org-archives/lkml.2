Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab2IEWGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:06:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab2IEWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:06:11 -0400
Message-ID: <5047CCCB.1000108@canonical.com>
Date: Wed, 05 Sep 2012 15:06:03 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: handle 32-bit userspace prctl
References: <20120827183813.GA23991@www.outflux.net>
In-Reply-To: <20120827183813.GA23991@www.outflux.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 11:38 AM, Kees Cook wrote:
> When running a 64-bit kernel and receiving prctls from a 32-bit
> userspace, the "-1" used as an unsigned long will end up being
> misdetected. The kernel is looking for 0xffffffffffffffff instead of
> 0xffffffff. Since prctl lacks a distinct compat interface, Yama needs
> to handle this translation itself. As such, support either value as
> meaning PR_SET_PTRACER_ANY, to avoid breaking the ABI for 64-bit.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> ---
>  security/yama/yama_lsm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index 0cc99a3..dcd6178 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -143,7 +143,7 @@ static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  		if (arg2 == 0) {
>  			yama_ptracer_del(NULL, myself);
>  			rc = 0;
> -		} else if (arg2 == PR_SET_PTRACER_ANY) {
> +		} else if (arg2 == PR_SET_PTRACER_ANY || (int)arg2 == -1) {
>  			rc = yama_ptracer_add(NULL, myself);
>  		} else {
>  			struct task_struct *tracer;
> 

yeah this looks good it should at least hit stable

Acked-by: John Johansen <john.johansen@canonical.com>

