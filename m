Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0L3SRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:17:01 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:60591 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754614Ab0L3SRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:17:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=V76iWoJsT58sKtA9nZZa7qWnNJAZc1TAXw6OQRVeGTjXpkw7MWBe979ErbCKJS/5RzHeJa5ccWRgC02ZzJ+tMtVkaVQbBZhJXS7krj2xWkaradvUkRKersNOQgPYPekw;
Date: Thu, 30 Dec 2010 10:16:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <20101230101658.1d3a7837@jbarnes-desktop>
In-Reply-To: <Pine.LNX.4.64.1012301045170.5207@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1012301045170.5207@boston.corp.fedex.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 10:49:33 +0800 (SGT)
Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> 
> On Thu, Dec 30, 2010 at 4:16 AM, Jesse Barnes <jbarnes@virtuousgeek.org> 
> wrote:
> 
> > Randy, Jeff and Alex, does the below help at all?  If so, it may be the
> > minimal fix we want for 2.6.37.
> 
> Jesse,
> 
> Yes, that worked for me. I improved on the patch a bit below.
> 
> Thanks,
> Jeff
> 
> 
> --- a/drivers/gpu/drm/i915/intel_bios.c	2010-12-29 13:35:57.000000000 +0800
> +++ a/drivers/gpu/drm/i915/intel_bios.c	2010-12-30 10:18:39.000000000 +0800
> @@ -262,7 +262,10 @@
>   	if (general) {
>   		dev_priv->int_tv_support = general->int_tv_support;
>   		dev_priv->int_crt_support = general->int_crt_support;
> -		dev_priv->lvds_use_ssc = general->enable_ssc;
> +
> +		/* force disable until we can parse this correctly */
> +		dev_priv->lvds_use_ssc = (IS_GEN5(dev) || IS_GEN6(dev)) ?
> +			0 : general->enable_ssc;

For some expressions, the ternary operator is more compact & readable.
For others (like this one imo) it doesn't really add anything, so I
prefer the if statement.  In this case I think the if statement is more
readable since it communicates that we're overriding the default value
on certain generations (i.e. it's a standalone clause).

-- 
Jesse Barnes, Intel Open Source Technology Center
