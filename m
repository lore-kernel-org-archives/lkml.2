Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1KSQGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 11:06:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42886 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1KSQGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 11:06:53 -0500
Message-ID: <4EC7D419.1090404@gmail.com>
Date: Sat, 19 Nov 2011 17:06:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, richard@nod.at,
        containers@lists.linux-foundation.org, oleg@redhat.com,
        eparis@redhat.com, linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH 1/1] __send_signal: pass q->info, not info, to userns_fixup_signal_uid
 (v2)
References: <20111119004148.GA16259@sergelap>
In-Reply-To: <20111119004148.GA16259@sergelap>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2011 01:41 AM, Serge Hallyn wrote:
> Eric Biederman pointed out that passing info is a bug and could lead
> to a NULL pointer deref to boot.

It would be great if you could describe what bug you are fixing in fact
in the commit log. "Something that could lead to a bug" is not helpful
at all.

A link to the thread where Eric pointed *that* out would be enough.

> A collection of signal, securebits, filecaps, cap_bounds, and a few other ltp
> tests passed with this kernel.
> 
> Changelog:
>     Nov 18: previous patch missed a leading '&'
> 
> Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> ---
>  kernel/signal.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index c0f0782..170586b 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1118,7 +1118,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			break;
>  		}
>  
> -		userns_fixup_signal_uid(info, t);
> +		userns_fixup_signal_uid(&q->info, t);
>  
>  	} else if (!is_si_special(info)) {
>  		if (sig >= SIGRTMIN && info->si_code != SI_USER) {

thanks,
-- 
js
