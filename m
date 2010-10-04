Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0JDKqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:46:04 -0400
Received: from www.tglx.de ([62.245.132.106]:60330 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab0JDKqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:46:02 -0400
Date: Mon, 4 Oct 2010 12:47:39 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] uio: Implement hotunplug support, using libunload
Message-ID: <20101004104739.GA9961@silverbox.local>
References: <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
 <20100924104555.GC1819@silverbox.local>
 <m1hbhfcbdo.fsf@fess.ebiederm.org>
 <20100924173106.GA4966@silverbox.local>
 <m14ode662q.fsf@fess.ebiederm.org>
 <20100925003308.GA29910@suse.de>
 <m1wrqa4mg5.fsf@fess.ebiederm.org>
 <20100926192142.GA7252@kroah.com>
 <m1iq1s86jk.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iq1s86jk.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 03:49:03PM -0700, Eric W. Biederman wrote:

Checkpatch reports one error, see below.

Thanks,
Hans

> 
> +	/*
> +	 * Take the users lock before opening the file to ensure the
> +	 * file is not unregistered while it is being opened.
> +	 */
> +	ret = -EIO;
> +	if (!unload_trylock(&idev->unload))
> +		goto err_out;
> +
> +	ret = 0;
> +	if (idev->info->open)
>  		ret = idev->info->open(idev->info, inode);
> -		if (ret)
> -			goto err_infoopen;
> +	

The above line adds trailing whitespace.

> +	/*
> +	 * Add to the listener list only if the open succeeds.
> +	 * This ensures that uio_unregister_device won't call
> +	 * release unless open has succeeded.
> +	 */
