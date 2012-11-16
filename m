Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2KPWc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:32:57 -0500
Received: from blackhole.sdinet.de ([176.9.52.58]:46516 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab2KPWc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:32:56 -0500
Date: Fri, 16 Nov 2012 23:32:32 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bill Nottingham <notting@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: removal of sysfs wext extension broke on F16
In-Reply-To: <1353098379.9490.22.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.DEB.2.02.1211162330090.19580@aurora.sdinet.de>
References: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>  <1352795227.9466.8.camel@jlt4.sipsolutions.net>  <CA+55aFw8Rx6TScXV_nsh4EFeCDTxsjn9mJPqo8VzPhbG9jC5Fw@mail.gmail.com>  (sfid-20121116_192027_176167_6DFB40B3)
 <1353098137.9490.20.camel@jlt4.sipsolutions.net>  (sfid-20121116_213518_404111_CB0441EC) <1353098204.9490.21.camel@jlt4.sipsolutions.net>  (sfid-20121116_213631_514198_885B62C5) <1353098379.9490.22.camel@jlt4.sipsolutions.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Johannes Berg wrote:

> On Fri, 2012-11-16 at 21:36 +0100, Johannes Berg wrote:
> > On Fri, 2012-11-16 at 21:35 +0100, Johannes Berg wrote:
> > > On Fri, 2012-11-16 at 10:20 -0800, Linus Torvalds wrote:
> > > > On Tue, Nov 13, 2012 at 12:27 AM, Johannes Berg
> > > > <johannes@sipsolutions.net> wrote:
> > > > >
> > > > > Should I revert it and send it in my next pull request?
> > > > 
> > > > Please do. Or perhaps we could just add the directory back, without
> > > > the actual entries, if that is sufficient..
> > > 
> > > Yeah, that does seem to be sufficient, I'll queue up the patch below.
> > 
> > Err, no, wishful thinking. I need a *little* bit more for sysfs to work.
> 
> This works, sorry about that.

> +#if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
> +static struct attribute *wireless_attrs[] = {
> +	NULL
> +};
> +
> +static struct attribute_group wireless_group = {
> +	.name = "wireless",
> +	.attrs = wireless_attrs,
> +};
> +#endif
>  #endif /* CONFIG_SYSFS */
>  

How about a small comment in the source why it is there? I suppose 
otherwise in a year or two someone will find it, see "WTF? Useless 
empty directory?" and try to remove it again...

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
