Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098Ab2JWWw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:52:29 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:45133 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933983Ab2JWWw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:52:28 -0400
Message-ID: <1351032742.5283.69.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ben Greear <greearb@candelatech.com>
CC: David Miller <davem@davemloft.net>, <cardoe@cardoe.com>, <kaber@trash.net>,
        <netdev@vger.kernel.org>, <systemd-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 23 Oct 2012 23:52:22 +0100
In-Reply-To: <5086C256.20202@candelatech.com>
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
	 <20121023.023647.2164665243829038911.davem@davemloft.net>
	 <5086C256.20202@candelatech.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 09:14 -0700, Ben Greear wrote:
> On 10/22/2012 11:36 PM, David Miller wrote:
> > From: Doug Goldstein <cardoe@cardoe.com>
> > Date: Mon, 22 Oct 2012 00:53:57 -0500
> >
> >> Sets the sysfs device_type to 'vlan' for udev. This makes it easier for
> >> applications that query network information via udev to identify vlans
> >> instead of using strrchr().
> >>
> >> Signed-off-by: Doug Goldstein <cardoe@cardoe.com>
> >
> > You're extremely misguided.  This change, in fact, makes it ten times
> > harder for such applications to query such devices.
> 
> If the application doesn't care, it can use the old way (which at least
> for me, involves string-comparing the driver name ethtool returns, which
> sucks at best).

The 'old way' that has only worked since Linux 2.6.29 (3.5 years)?

The 'right way' seems to be to query for VLAN information through
netlink.  But that has only worked since Linux 2.6.23 (5 years ago).
The real 'old way' is to use SIOCGIFVLAN. :-/

> And applications that care might suddenly have more features, or be more
> efficient when running on newer kernels..

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

