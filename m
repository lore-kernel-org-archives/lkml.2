Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1EDUzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:55:39 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:20129 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1EDUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:55:35 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k/CuK6Xob0=
X-RZG-CLASS-ID: mo00
Message-ID: <4DC1BD3D.800@hartkopp.net>
Date: Wed, 04 May 2011 22:55:25 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>	<201104271525.28512.arnd@arndb.de>	<15AD189F851849F69A011B6F4D1DDB6C@subhasishg>	<201105041511.54095.arnd@arndb.de>	<4DC163D7.9010309@grandegger.com> <20110504155750.GC322@e-circ.dyndns.org> <4DC17A31.8070409@grandegger.com>
In-Reply-To: <4DC17A31.8070409@grandegger.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2011 18:09, Wolfgang Grandegger wrote:

> On 05/04/2011 05:57 PM, Kurt Van Dijck wrote:

>> When doing so, I'd vote for an unlimited(by software) list of hardware filters (id/mask).
>> The hardware must abort when no more filters are available.
> 
> Sounds good and not even to complicated. For the SJA1000 we would just
> allow to set the global mask.

Yes. "unlimited(by software)" was a bit misleading at first reading, as we
should not filter IDs by software in the irq handler. But to create a API that
supports as much HW filters as the hardware provides is a good idea.

>> I think that when using hardware filters, knowing the actual device
>> with it's amount of hardware filters is the least of your problems.
>> Userspace applications that suddenly stop working properly due to
>> hw filters (i.e. some traffic not coming in anymore) will be a major
>> source of bugreports.
> 
> Well, hardware filtering will be off by default and must explicitly be
> set by the user, like for the bitrate setting.

To be correct: By the admin.

The setting of CAN HW filters has a system-wide effect to all users on the
local host. The same effect as we have for the setting of the bitrate. This is
the major difference to the user-configurable per-socket CAN-ID filters that
are provided e.g. by the CAN_RAW socket.

As the current netlink configuration interface for CAN interfaces is not
accessible for standard users also this would be the right place to extend the
netlink interface.

Regards,
Oliver
