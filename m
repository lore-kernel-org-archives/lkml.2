Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1FQDvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:51:41 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:51995 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab1FQDvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:51:39 -0400
Subject: Re: [PATCH] sky2: avoid using uninitialized variable
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, gthelen@google.com, shemminger@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110616.231018.84570655636629416.davem@davemloft.net>
References: <20110613181212.571f8e76@s6510.ftrdhcpuser.net>
	 <BANLkTi=jw5=9LcwxnXW6xNkF4RbFhHaB55Au=oDhn1yYWf53dA@mail.gmail.com>
	 <20110614000230.4166a1ae@s6510.ftrdhcpuser.net>
	 <20110616.231018.84570655636629416.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Fri, 17 Jun 2011 04:51:35 +0100
Message-ID: <1308282695.11457.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2011 03:51:39.0325 (UTC) FILETIME=[DCD5AED0:01CC2CA1]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18202.004
X-TM-AS-Result: No--24.063400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 23:10 -0400, David Miller wrote:
> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Tue, 14 Jun 2011 00:02:30 -0400
> 
> > In my experience if phy reads once successfully, it is going
> > to read every time. If there is a problem it only happens on
> > the first access (powered off, bad timing, etc).
> 
> It also happens when the PHY can't get a response for a certain
> register, for whatever reason, before internal hw timeouts trigger.
> 
> Please, check all MII accesses.  That's what I do in every driver
> I've written.

It doesn't help that the mii_if_info operations are defined to never
return errors.  This doesn't prevent drivers from doing so internally,
but it does set a bad example.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

