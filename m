Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab1D1Sms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:42:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab1D1Smr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:42:47 -0400
Date: Thu, 28 Apr 2011 14:42:34 -0400
From: Jason Baron <jbaron@redhat.com>
To: Anders Kaseorg <andersk@ksplice.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: Fix jump_label_text_reserved
Message-ID: <20110428184234.GB2559@redhat.com>
References: <alpine.DEB.2.02.1104281346060.14343@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1104281346060.14343@dr-wily.mit.edu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 01:53:43PM -0400, Anders Kaseorg wrote:
> This typo prevented jump_label_text_reserved from checking for any
> conflicts in the core kernel.
> 
> Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
> ---
>  kernel/jump_label.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 3b79bd9..4aedde1 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -250,7 +250,7 @@ int jump_label_text_reserved(void *start, void *end)
>  {
>  	struct jump_entry *iter;
>  	struct jump_entry *iter_start = __start___jump_table;
> -	struct jump_entry *iter_stop = __start___jump_table;
> +	struct jump_entry *iter_stop = __stop___jump_table;
>  	int conflict = 0;
>  
>  	iter = iter_start;
> -- 
> 1.7.5
> 

This is fixed in the jump label re-write patch, which is queued for
2.6.40 in the -tip tree. See: http://marc.info/?l=linux-kernel&m=130391786701337&w=2

I believe only kprobes is relying on this check. Did you hit this in
practive using kprobes?

Thanks,

-Jason
