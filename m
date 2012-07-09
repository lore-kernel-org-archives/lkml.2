Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2GIIpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 04:45:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab2GIIpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 04:45:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: comment on pm tree commit
Date: Mon, 9 Jul 2012 10:24:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <20120709094013.88a1117c9ef4510555147280@canb.auug.org.au>
In-Reply-To: <20120709094013.88a1117c9ef4510555147280@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207091024.34585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 09, 2012, Stephen Rothwell wrote:
> Hi Rafael,
> 
> I noticed commit b8eec56cd8e5 ("PM / cpuidle: System resume hang fix with
> cpuidle") in the pm tree needs some work (I noticed it because it was
> changed in a rebase ...).
> 
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index a6b3f2e..b90ccb2 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -146,6 +146,8 @@ extern void cpuidle_unregister_device(struct cpuidle_device *dev);
>  
>  extern void cpuidle_pause_and_lock(void);
>  extern void cpuidle_resume_and_unlock(void);
> +extern void cpuidle_pause(void);
> +extern void cpuidle_resume(void);
>  extern int cpuidle_enable_device(struct cpuidle_device *dev);
>  extern void cpuidle_disable_device(struct cpuidle_device *dev);
>  extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
> @@ -169,6 +171,8 @@ static inline void cpuidle_unregister_device(struct cpuidle_device *dev) { }
>  
>  static inline void cpuidle_pause_and_lock(void) { }
>  static inline void cpuidle_resume_and_unlock(void) { }
> +static inline cpuidle_pause(void) { }
> +static inline cpuidle_resume(void) { }
> 
> These need to be "static inline void".  I wonder what review and build
> testing this went through (the above should produce warnings since they
> are non void returning functions with no return statements).

Thanks for reporting this, I tried to fix a build issue in the original patch
hastily and failed miserably as you have noticed and then I build-tested a
wrong tree.  Sorry.

It should be fixed now for real.

Thanks,
Rafael
