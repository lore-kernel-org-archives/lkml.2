Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1CCUEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:04:10 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14155 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab1CCUEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:04:09 -0500
Date: Thu, 3 Mar 2011 21:03:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: =?ISO-8859-15?Q?Nico_Sch=FCmann?= <dev@nico22.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Network link detection
In-Reply-To: <20110303193006.GA29129@svh.nico22.de>
Message-ID: <alpine.LNX.2.00.1103032100360.2430@swampdragon.chaosbits.net>
References: <20110303193006.GA29129@svh.nico22.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1345358779-1299182610=:2430"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1345358779-1299182610=:2430
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 3 Mar 2011, Nico Schümann wrote:

> Dear kernel developers,
> 
> currently I'm looking for a way to find out whether a network link went 
> down or up. Of course there is mii-tool, which can watch devices, too.
> 
> So for now, I created a small program that polls the MII_LINK_OK
> flag with the SIOCGMIIREG ioctl - the same thing that mii-tools does. 
> But polling that often for a link change that occurs maybe once in a 
> month sounds like waste of energy.
> 
> Unfortunately, I was not able to find out a way to be notified about 
> link status changes asynchronously. Is there a way? I'm looking for 
> something like "inotify for link states".
> 
I guess you could use inotify to keep an eye on the 'carrier' file in 
sysfs (for example, from my system; 
/sys/devices/pci0000:00/0000:00:19.0/net/eth0/carrier )
That file will contain "0" if there is no link and "1" if there is a link.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

--8323328-1345358779-1299182610=:2430--
