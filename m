Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0CXOGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:06:35 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60604 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab0CXOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=l9IY02Gfntg+k353tkFytUv7VU3x32v725farmy71H6NTzU/ukWPsTNvnTNAnhAZY2
         CO5aiD42JR4v90PrE6Np78cDjXAVzvIX8tB3iJUMXiLP3tubrulniCRTaIEaZWukmHyr
         pJsZlh30kZ7gz4l0hTYkc9Ez3GvHsHEpKyF/0=
Date: Wed, 24 Mar 2010 17:06:21 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, Joonyoung Shim <jy0922.shim@samsung.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [rfc patch] wm8994: range checking issue
Message-ID: <20100324140621.GI21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100324120107.GH21571@bicker> <20100324125946.GA26453@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324125946.GA26453@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 12:59:46PM +0000, Mark Brown wrote:
> On Wed, Mar 24, 2010 at 03:01:07PM +0300, Dan Carpenter wrote:
> > Smatch complained about BUG_ON(reg > WM8994_MAX_REGISTER) because the
> > actual number of elements in the array was WM8994_REG_CACHE_SIZE + 1.
> 
> > I changed the BUG_ON() to return -EINVAL.
> 
> Please don't introduce orthogonal changes like this in patches, it's bad
> practice and increases the chances of your patch being nacked.
> 
> > I was confused why WM8994_REG_CACHE_SIZE was different from the actual
> > size of ->reg_cache and I was concerned because some places used 
> > ARRAY_SIZE() to find the end of the array and other places used 
> > WM8994_REG_CACHE_SIZE.  In my patch, I made them the same.
> 
> This is caused by confusion with the MAX_CACHED_REGISTER definition in
> the header.  Best to use that one consistently, I guess - I've got a
> sneaking suspicion something has gone AWOL in the driver publication
> process.


Hm...  That sounds more involved than I anticipated.  I don't have the
hardware and don't feel comfortable making complicated changes if I
can't test them.

Can someone else take care of this.

regards,
dan carpenter
