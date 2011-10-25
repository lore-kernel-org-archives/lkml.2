Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1JYP30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:29:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab1JYP3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:29:23 -0400
Date: Tue, 25 Oct 2011 17:29:22 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
Message-ID: <20111025152922.GB2731@tiehlicka.suse.cz>
References: <20111025184002.d70aeb245a4b9016635df242@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025184002.d70aeb245a4b9016635df242@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 25-10-11 18:40:02, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> include/asm-generic/cputime.h between commit f6116715d1ba ("[S390]
> cputime: add sparse checking and cleanup") from the cputime tree and
> commit ef0e0f5ed9bd ("cputime: Clean up cputime_to_usecs and
> usecs_to_cputime macros") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

This one looks good as well.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc include/asm-generic/cputime.h
> index 77202e2,62ce682..0000000
> --- a/include/asm-generic/cputime.h
> +++ b/include/asm-generic/cputime.h
> @@@ -23,10 -38,8 +23,10 @@@ typedef u64 __nocast cputime64_t
>   /*
>    * Convert cputime to microseconds and back.
>    */
>  -#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
>  -#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
>  +#define cputime_to_usecs(__ct)		\
> - 	jiffies_to_usecs(cputime_to_jiffies(__ct));
> ++	jiffies_to_usecs(cputime_to_jiffies(__ct))
>  +#define usecs_to_cputime(__msecs)	\
> - 	jiffies_to_cputime(usecs_to_jiffies(__msecs));
> ++	jiffies_to_cputime(usecs_to_jiffies(__msecs))
>   
>   /*
>    * Convert cputime to seconds and back.



-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
