Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2JEQZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:25:50 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:34639 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab2JEQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:25:44 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2012 12:25:44 EDT
Date: Fri, 5 Oct 2012 11:50:06 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: [PATCH 07/16] cgroup: fix warning when building without any
 subsys
Message-ID: <20121005155006.GB5124@ghc17.ghc.andrew.cmu.edu>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
 <1349448930-23976-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349448930-23976-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.18.170322
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1600_1699 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_SUBJECT 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 04:55:21PM +0200, Arnd Bergmann wrote:
> In a configuration where the base cgroup support is enabled but
> every single cgroup subsys is turned off, CGROUP_BUILTIN_SUBSYS_COUNT
> is zero, which causes the sanity check code in cgroup_load_subsys
> to trigger:
> 
>        BUG_ON(ss->subsys_id >= CGROUP_BUILTIN_SUBSYS_COUNT);
>        BUG_ON(subsys[ss->subsys_id] != ss);
> 
> Gcc first confirms that subsys_id cannot be 0 or larger and consequently
> warns in the second line.
> 
> kernel/cgroup.c: In function 'cgroup_load_subsys':
> kernel/cgroup.c:4326:38: warning: array subscript is below array bounds [-Warray-bounds]
> 
> Since the subsys_id can never be less than zero, we can just change the
> type to an unsigned int, which makes the warning go away.
> 
> Found by building ARM cns3420vb_defconfig.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Ben Blum <bblum@andrew.cmu.edu>
> ---
>  include/linux/cgroup.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index c90eaa8..26b99df 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -475,7 +475,7 @@ struct cgroup_subsys {
>  	void (*post_clone)(struct cgroup *cgrp);
>  	void (*bind)(struct cgroup *root);
>  
> -	int subsys_id;
> +	unsigned int subsys_id;
>  	int active;
>  	int disabled;
>  	int early_init;
> -- 
> 1.7.10
> 
> 

Oops. Thank you!

Acked-by: Ben Blum <bblum@andrew.cmu.edu>
