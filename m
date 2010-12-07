Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0LGOE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:04:26 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47582 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0LGOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:04:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 7 Dec 2010 15:04:11 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>,
        Robin Cook <rcook@wyrms.net>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
Message-ID: <20101207150411.11bb5889@stein>
In-Reply-To: <4CFDFBB0.8050804@ladisch.de>
References: <1291592226.7134.1.camel@pheuri.wyrms.net>
	<1291594279.9196.2.camel@maxim-laptop>
	<20101206082918.6d1ccc41@stein>
	<1291673087.4022.2.camel@pheuri.wyrms.net>
	<20101207092735.48b82c40@stein>
	<4CFDFBB0.8050804@ladisch.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 07 Clemens Ladisch wrote:
> Stefan Richter wrote:
> > I wonder which of our options is preferable:
> >   - Change fw-ohci from MSI blacklisting to whitelisting.  Agere FW643
> >     rev 07 is the only chip that can be whitelisted.
> >   - Simply drop MSI support altogether.

Blacklisting is also still an option if we extend the table by a
revision field:
   match = ... && (ohci_quirks[i].revision == ANY_REVISION ||
                   dev->revision <= ohci_quirks[i].revision) && ...;
If we ever need an dev->revision >= ohci_quirks[i].revision match, the
"break after first match" rule can be put to use or more tricks be
added.

> That depends on whether the maintainer can afford the effort of
> maintaining the whitelist.

I heard the maintainer is an FW643-E owner.  Maybe he accepts the
maintenance burden for personal gain (less MMIO reads than with shared
IRQs).  He might get fed up when new 1394 controllers with working MSI
support start to appear on the market in a monthly rhythm or so.

Blacklist maintenance OTOH would be worse for all concerned, since
evidently not every MSI related bug is so easy to identify like with
JMB38x and VT6315.  Even such simple cases will become more problematic
as more time goes by since the 2.6.36 release.  Though with the current
rate of OHCI 1394 product releases, blacklisting seems not to be a big
deal either.
-- 
Stefan Richter
-=====-==-=- ==-- --===
http://arcgraph.de/sr/
