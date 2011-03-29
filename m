Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1C2N2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:28:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1C2N2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:28:47 -0400
Date: Tue, 29 Mar 2011 14:19:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Julien Tinnes <jln@google.com>,
        Klaus Dittrich <kladit@arcor.de>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH v2] Relax si_code check in rt_sigqueueinfo and
	rt_tgsigqueueinfo
Message-ID: <20110329121937.GA27497@redhat.com>
References: <1301346815-6755-1-git-send-email-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301346815-6755-1-git-send-email-roland@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Roland Dreier wrote:
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 324eff5..b2bfa3a 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2437,7 +2437,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
>  	/* Not even root can pretend to send signals from the kernel.
>  	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
>  	 */
> -	if (info.si_code != SI_QUEUE) {
> +	if (info.si_code >= 0 || info.si_code == SI_TKILL) {
>  		/* We used to allow any < 0 si_code */
>  		WARN_ON_ONCE(info.si_code < 0);

This is equivalent to WARN_ON_ONCE(SI_TKILL)... doesn't matter, please ignore.

Thanks, I think -stable needs this patch asap. It turns out 2.6.32.36, 2.6.33.9,
2.6.37.6 and 2.6.38.2 pulled da48524eb20662618854bb3df2db01fc65f3070c.

If this change breaks something too, we can make even more conservative check.

Acked-by: Oleg Nesterov <oleg@redhat.com>

