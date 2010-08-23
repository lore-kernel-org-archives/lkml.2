Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0HWNne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:43:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33250 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0HWNnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:43:32 -0400
Date: Mon, 23 Aug 2010 07:43:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>,
        john stultz <johnstul@us.ibm.com>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
Message-ID: <20100823134330.GM12892@parisc-linux.org>
References: <cover.1282550649.git.richard.cochran@omicron.at> <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at> <201008231457.26690.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008231457.26690.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 02:57:26PM +0200, Arnd Bergmann wrote:
> > +static inline int common_clock_adj(const clockid_t which_clock, int ppb,
> > +				   struct timespec *tp)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> >  static int no_timer_create(struct k_itimer *new_timer)
> >  {
> >  	return -EOPNOTSUPP;
> 
> So we already return -EOPNOTSUPP in some cases? The man page does not document this.
> I wonder if we should change that to -EINVAL as well.

ENOTTY is the usual errno for "inappropriate ioctl for device".  Due to
the way this patch has been chopped up, I can't tell if that's what is
intended here.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
