Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0ICJ6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:58:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57586 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0ICJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N7CQ7Paqs5HcMnbiJ1SMPURgb8fyIUoVXd1WFBhIg6uR2dMeWJOPGr/p68vVsgMBLA
         RnOtuljhX+4BHpw+lcC7kWo6L5Cic44Xjg5CSjdWPd5ocGv2sarrRD9x7iQDmufGlugD
         UR7U1AGHPV5TbSnX22IuAxSRwW7WUWkLN1EEQ=
Date: Fri, 3 Sep 2010 11:58:32 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] posix clocks: introduce a syscall for clock tuning.
Message-ID: <20100903095832.GA22138@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <7f4815cdfcf5bc49df4bdd09d59a4f56ca2598f5.1283504065.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f4815cdfcf5bc49df4bdd09d59a4f56ca2598f5.1283504065.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 11:29:05AM +0200, Richard Cochran wrote:
> +long compat_sys_clock_adjtime(clockid_t which_clock,
> +		struct compat_timex __user *utp)
> +{
> +	struct timex txc;
> +	mm_segment_t oldfs;
> +	int err, ret;
> +
> +	err = compat_get_timex(&txc, utp);
> +	if (err)
> +		return err;
> +
> +	oldfs = get_fs();
> +	set_fs(KERNEL_DS);
> +	ret = sys_clock_adjtime(which_clock, (struct timex __user *) &txc);
> +	set_fs(oldfs);

I don't know what the purpose of get_fs, set_fs is, but the other
clock_ functions have it that way. The adjtimex call does not have
this at all, so I ask, do we need this here, or not?

Thanks,
Richard
