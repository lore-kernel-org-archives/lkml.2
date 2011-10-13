Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1JMRZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:25:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab1JMRZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:25:33 -0400
Date: Thu, 13 Oct 2011 11:25:19 -0600
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH 0/5] Better namespace handling for
 /sys/class/net/bonding_masters
Message-ID: <20111013172519.GA30682@suse.de>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hb3dbae5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:47:46AM -0700, Eric W. Biederman wrote:
> 
> When I was looking at another sysfs issue that Al pointed out (since
> fixed) I realized that I had implemented a trivial code size but overly
> clever way to handle /sys/class/net/bonding_masters.
> 
> This patchset removes the support for untagged entries in tagged
> directories (that is currently used to support bonding_masters)
> and replaces it with support for tagged sysfs attributes.
> 
> In the process this fixes a small misfeature in how bonding_masters
> derives the network namespace we are dealing with.  This change
> allows bonding_masters to derive the network namespace from the
> copy of bonding_masters we open instead of magically from current.
> 
> The final patch of this patchset adds sanity checks to sysfs.  To
> ensure that we don't accidentally mishandle tagged sysfs entities.
> 
> I have tested this code against 3.1-rc9 on my laptop with a mostly yes
> config and I am not seeing any problems.  The loud screaming warnings I
> have added in the last patch should catch any corner cases in how people
> use sysfs that I might have overlooked.
> 
> Greg, Dave I'm don't know whose tree to merge this through as this code
> is equally device-core and networking.  I am hoping that we can get this
> improvement merged for 3.2.

These all look fine to me, and I have no problem with them going through
the network tree as that will most likely be the easiest way due to any
potential merge issues.

David, feel free to add an:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to these patches and take them through your tree if that is ok with you.
If not, I can also always take them through mine, it's your choice.

thanks,

greg k-h
