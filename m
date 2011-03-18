Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1CRBxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 21:53:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079Ab1CRBxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 21:53:11 -0400
Date: Thu, 17 Mar 2011 18:50:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        jwjstone@fastmail.fm, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] watchdog, nmi:  Allow hardlockup to panic by
 default
Message-Id: <20110317185013.7c8be1e0.akpm@linux-foundation.org>
In-Reply-To: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
References: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Mar 2011 16:37:39 -0500 Don Zickus <dzickus@redhat.com> wrote:

> Add a Kconfig option to allow users to set the hardlockup to panic
> by default.  Also add in a 'nmi_watchdog=nopanic' to override this.
> 

Changelog forgot to tell us "why".

>  			Format: [state][,regs][,debounce][,die]
>  
>  	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
> -			Format: [panic,][num]
> +			Format: [panic,][nopanic,][num]

It would be better to support panic=[0|1], if that can be simply done
in a back-compatible fashion.

>  static int __init hardlockup_panic_setup(char *str)
>  {
>  	if (!strncmp(str, "panic", 5))
>  		hardlockup_panic = 1;
> +	else if (!strncmp(str, "nopanic", 5))

s/5/7/

> +		hardlockup_panic = 0;
>  	else if (!strncmp(str, "0", 1))
>  		watchdog_enabled = 0;
>  	return 1;

