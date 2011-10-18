Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1JRGON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:14:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab1JRGOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:14:12 -0400
Date: Tue, 18 Oct 2011 08:12:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>, stable@kernel.org
Subject: Re: [PATCH 2/5] oprofile: Fix crash when unloading module (hr timer
Message-ID: <20111018061226.GC16304@elte.hu>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
 <1318861624-715-3-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318861624-715-3-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> +	/* failed */
> +	if (timer_mode)
> +		oprofile_timer_exit();
> +	else
> +		oprofile_arch_exit();

> -	oprofile_arch_exit();
> +	if (timer_mode)
> +		oprofile_timer_exit();
> +	else
> +		oprofile_arch_exit();

That's rather ugly ...

Thanks,

	Ingo
