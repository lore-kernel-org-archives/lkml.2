Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab1FXW26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:28:58 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58856 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757081Ab1FXW2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:28:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pwDU8LOy/Zk4JkwxF3qv1IyrFxxsupedAk/5VpGekuDtJHRrPABKXz3PjQePEjPTSYx5KydgLDTkQ5eejJ9v6OZRFHKhMaqKmvRFuELXAJQxkBZegkD9wGPNU+4Dl8DA;
Date: Fri, 24 Jun 2011 15:28:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] sparse: Fix BUILD_BUG_ON_{ZERO,NULL} definitions
Message-Id: <20110624152853.6fd65f41.rdunlap@xenotime.net>
In-Reply-To: <1308951912.3034.23.camel@bwh-desktop>
References: <1308951912.3034.23.camel@bwh-desktop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 22:45:12 +0100 Ben Hutchings wrote:

> Commit 903c0c7cdc21f2ccb7562a7bbc70289c0c2b16ad ('sparse: define dummy
> BUILD_BUG_ON definition for sparse') left these two broken.  The ZERO
> or NULL suffix specifies what the macro should expand to, not the
> value that would indicate a bug.
> 
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> ---
> sparse currently reports a syntax error and no useful warnings for any
> source file which uses one of these macros.  Since module_param() uses
> BUILD_BUG_ON_ZERO(), that's a lot of source files.
> 
> Ben.

This patch from 2011-MAY-30 also fixes these warnings, but the typecasting
in yours is probably better.  :)

http://marc.info/?l=linux-kernel&m=130677145629121&w=2

Wait, 3.0-rc4 already has the above patch.  Is yours still needed?


>  include/linux/kernel.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index fb0e732..fccd366 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -671,8 +671,8 @@ struct sysinfo {
>  
>  #ifdef __CHECKER__
>  #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
> -#define BUILD_BUG_ON_ZERO(e)
> -#define BUILD_BUG_ON_NULL(e)
> +#define BUILD_BUG_ON_ZERO(e) ((size_t)0)
> +#define BUILD_BUG_ON_NULL(e) ((void *)0)
>  #define BUILD_BUG_ON(condition)
>  #else /* __CHECKER__ */
>  
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
