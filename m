Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab1CCT6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:58:20 -0500
Received: from sv2.nico22.de ([62.112.144.130]:40796 "EHLO sv2.nico22.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab1CCT6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:58:19 -0500
X-Greylist: delayed 1683 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 14:58:19 EST
Date: Thu, 3 Mar 2011 20:30:06 +0100
From: Nico =?iso-8859-1?Q?Sch=FCmann?= <dev@nico22.de>
To: linux-kernel@vger.kernel.org
Subject: Network link detection
Message-ID: <20110303193006.GA29129@svh.nico22.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel developers,

currently I'm looking for a way to find out whether a network link went 
down or up. Of course there is mii-tool, which can watch devices, too.

So for now, I created a small program that polls the MII_LINK_OK
flag with the SIOCGMIIREG ioctl - the same thing that mii-tools does. 
But polling that often for a link change that occurs maybe once in a 
month sounds like waste of energy.

Unfortunately, I was not able to find out a way to be notified about 
link status changes asynchronously. Is there a way? I'm looking for 
something like "inotify for link states".

There are some debug outputs as in drivers/net/natsemi.c:1672
                        printk(KERN_NOTICE "%s: link up.\n", dev->name);
so it would be quite easy to insert a notification.

If there is no way yet to get these notifications asynchronosly, would 
there be real use for it or am I just missing something?

Thanks,

Nico
