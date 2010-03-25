Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0CYK6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:58:34 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37038 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0CYK6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KGrP5rM7mXvf4GCuijbTQiGtyBb1wqJwZ2ibjo8puXYS81HMZzeo8MoK7SmgrT+8Ud
         Qq1+ieZVmh9rJEFmucqfnag+bRKXOz6F5zFtxGOahq20OgnGNGfYj4PM9YTL2P3vPc7G
         JstVHPN9oJNccTH4/T/NVwBA2D1YIPeWBT5gY=
Date: Thu, 25 Mar 2010 13:58:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, Joonyoung Shim <jy0922.shim@samsung.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [rfc patch] wm8994: range checking issue
Message-ID: <20100325105822.GE5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100324120107.GH21571@bicker> <20100324125946.GA26453@rakim.wolfsonmicro.main> <20100324140621.GI21571@bicker> <20100324143139.GE26453@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324143139.GE26453@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 02:31:39PM +0000, Mark Brown wrote:
> On Wed, Mar 24, 2010 at 05:06:21PM +0300, Dan Carpenter wrote:
> > On Wed, Mar 24, 2010 at 12:59:46PM +0000, Mark Brown wrote:
> 
> > > This is caused by confusion with the MAX_CACHED_REGISTER definition in
> > > the header.  Best to use that one consistently, I guess - I've got a
> > > sneaking suspicion something has gone AWOL in the driver publication
> > > process.
> 
> > Hm...  That sounds more involved than I anticipated.  I don't have the
> > hardware and don't feel comfortable making complicated changes if I
> > can't test them.
> 
> Not really, it's just a case of picking the value to standardise on for
> the size of the array instead of the one you picked.  However, now I
> look at it again REG_CACHE_SIZE is the one we want and _MAX_CACHED_REGISTER 
> is bitrot which should be removed.
> 
> I didn't look as closely as I might due to the extraneous changes for
> BUG_ON() I mentioned which meant the patch wouldn't be applied anyway.
> Those shouldn't be changed because there's no way anything in the kernel
> should be generating a reference to a register which doesn't physically
> exist (which is what they check for).
> 
> > Can someone else take care of this.
> 
> Actually, now I look even more closely there's further issues with the
> patch - you're missing the fact that the register cache is only used for
> non-volatile registers but all registers beyond the end of the register
> cache are treated as volatile.  This means that I'm not convinced there
> are any actual problems here, I'm not sure what analysis smatch is doing
> but it looks to have generated false positives here.
> 

Yup.  You are right, this is a false positive.  I'm very sorry about that, 
I misread the code as well.

The problem is that Smatch doesn't do cross function analysis yet.  :/

regards,
dan carpenter

> I'll send a patch for _MAX_CACHED_REGISTER later today.
