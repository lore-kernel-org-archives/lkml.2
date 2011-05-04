Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1EDP57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:57:59 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:60793 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab1EDP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:57:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABl3wU1tgmbn/2dsb2JhbACEUKFJeIhyqySRNYEqg1yBAQSTbooD
Date: Wed, 4 May 2011 17:57:50 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Message-ID: <20110504155750.GC322@e-circ.dyndns.org>
Mail-Followup-To: Wolfgang Grandegger <wg@grandegger.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Subhasish Ghosh <subhasish@mistralsolutions.com>,
	linux-arm-kernel@lists.infradead.org,
	Marc Kleine-Budde <mkl@pengutronix.de>, sachi@mistralsolutions.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Netdev@vger.kernel.org, nsekhar@ti.com,
	open list <linux-kernel@vger.kernel.org>,
	CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
	m-watkins@ti.com
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>
 <201104271525.28512.arnd@arndb.de>
 <15AD189F851849F69A011B6F4D1DDB6C@subhasishg>
 <201105041511.54095.arnd@arndb.de>
 <4DC163D7.9010309@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DC163D7.9010309@grandegger.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > How hard would it be to implement that feature in Socket CAN?
> 
> CAN controllers usually provide some kind of hardware CAN id filtering,
> but in a very hardware dependent way. A generic interface may be able to
> handle the PRUSS restrictions as well. CAN devices are usually
> configured through the netlink interface. e.g.
> 
>   $ ip link set can0 up type can bitrate 125000
> 
> and such a common interface would be netlink based as well.
ack.
> 
> > Is that something that Subhasish or someone else could to as a prerequisite
> > to merging the driver?
> 
> Any ideas on how to handle hardware filtering in a generic way are
> welcome. I will try to come up with a proposal sooner than later.

When doing so, I'd vote for an unlimited(by software) list of hardware filters (id/mask).
The hardware must abort when no more filters are available.
I think that when using hardware filters, knowing the actual device
with it's amount of hardware filters is the least of your problems.
Userspace applications that suddenly stop working properly due to
hw filters (i.e. some traffic not coming in anymore) will be a major
source of bugreports.

Kurt
