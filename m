Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1ELDDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 23:03:18 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:12841 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab1ELDDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 23:03:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAlNy01tggPx/2dsb2JhbACEVqEZeIhwr3SRN4Eqg2GBBgSGRJgx
Date: Wed, 11 May 2011 22:03:10 -0500
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
Subject: can: hardware vs. software filter
Message-ID: <20110512030245.GA253@e-circ.dyndns.org>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Subhasish Ghosh <subhasish@mistralsolutions.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	linux-arm-kernel@lists.infradead.org, sachi@mistralsolutions.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Netdev@vger.kernel.org, nsekhar@ti.com,
	open list <linux-kernel@vger.kernel.org>,
	CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
	m-watkins@ti.com
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>
 <2BFFDAA0A0DE4820876E5549867938EC@subhasishg>
 <201105112331.47954.arnd@arndb.de>
 <201105112344.44171.arnd@arndb.de>
 <4DCB103B.30801@pengutronix.de>
 <20110511235652.7ccddb3b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110511235652.7ccddb3b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:56:52PM +0100, Alan Cox wrote:
> > I'm not sure if reprogramming hardware filters on the fly works on evey
> > can core. The more conservative solution would be to configure the
> > filter list globally (+when the interface is down) via netlink.
> 
> For anything that isn't so braindead it ought to be done on the fly and
> behind the users back to avoid having to make app code specially aware.

> If the lists are fixed either in firmware or in software the stack needs
> to error attempts to use anything else

That is the best guarantee to let users never use this.
A tool like 'candump' should not know about any pre-configured
filter that is in place. It's the responsibility of the root user
to put proper preconfigured filters.

A lot of code would be spent to allow an application to request
software filters that fit in the preconfigured ones.
IMHO its the root users job to judge about a proper preconfigured
filter that suits the applications that run. The applications should
then be able to request any software filter they like, the root user
decided on limiting traffic.

This poses a problem in that an application may depend on these filters
for its proper operation. That exactly is the responsibility of the
root user who restricts the preconfigured filter.

Kurt
