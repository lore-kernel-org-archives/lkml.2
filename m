Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab0I0SFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:05:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:38258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0I0SF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:05:29 -0400
Date: Mon, 27 Sep 2010 10:54:12 -0700
From: Greg KH <gregkh@suse.de>
To: tmhikaru@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100927175412.GA23347@suse.de>
References: <20100927003608.GA20395@kroah.com> <20100927163208.GA4892@roll>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927163208.GA4892@roll>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 12:32:08PM -0400, tmhikaru@gmail.com wrote:
> 	I'm not exactly sure what's going on here and I'd like some help
> figuring out what is. For some inexplicable reason, ever since I started
> using the 2.6.35.x series with the 2.6.35.3 release, my loadaverages tend to
> bounce anywhere from as low to .2 to 1.5 - constantly, while the machine
> seems idle.

But .34 doesn't show this issue?

If so, can you run 'git bisect' between the .34 and .35 releases to find
out where the problem comes in?

> Consistently, there are no programs in D state in ps aux output,
> no cpu hogging programs running in top, nothing I can see that should
> explain the bizzarely high load average.

Loadaverage can be affected by a driver doing an uninteruptable sleep.
This doesn't actually cause a load on the system, but it does affect the
way that number is calcuated.  Perhaps that's the problem here.

> 	If you have any tips or recommendations on what I should use to
> investigate this further, please let me know. Once I have ensured to my own
> satisfaction that I'm not doing something bizzare that's screwing up my
> machine, I'll make a detailed bug report and start on figuring out how to
> use git bisect.

'man git-bisect' will help with this :)

thanks,

greg k-h
