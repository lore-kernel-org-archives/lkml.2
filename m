Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1ELHLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:11:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:32837 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab1ELHLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:11:11 -0400
X-Auth-Info: PHX+E2uwQMX1uX8j9q95/YeCqKALtcW8phC/J4beGxs=
Message-ID: <4DCB88A4.2010901@grandegger.com>
Date: Thu, 12 May 2011 09:13:40 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>	<2BFFDAA0A0DE4820876E5549867938EC@subhasishg>	<201105112331.47954.arnd@arndb.de> <201105112344.44171.arnd@arndb.de>
In-Reply-To: <201105112344.44171.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 11:44 PM, Arnd Bergmann wrote:
> On Wednesday 11 May 2011, Arnd Bergmann wrote:
>> If that interpretation is right, I would seriously recommend rethinking
>> the design of the CAN firmware for pruss, so you can start doing something
>> useful with the offload engine that fits into the Socket CAN API, or that
>> would be a useful extension to Socket CAN that is also implementable in
>> the kernel for all other drivers in a meaningful way.
> 
> I've looked some more into the CAN socket implementation, and I suppose that
> the idea of the pruss driver was really to help do the work from the
> can_rcv_filter function in hardware.

That software filter is per socket while the hardware filter will be per
device.

> Doing this right would really mean supporting both a mode where any new
> filter that gets added to socket can ends up being added to the hardware
> as long as it fits, similar to how we can add additional unicast mac
> addresses to an ethernet NIC. However, when the filters from all user
> sockets combined can not be represented in the hardware driver, the hardware
> needs to be put into a less efficient mode where all packets are returned
> to the kernel and processed in software.

Well, that seems sophisticated resulting in a complex implementation
(may code line) also because hardware filters are very hardware
dependent. Usually just one global filter can be defined. I think that's
overkill. A simple interface using:

  ip link set can0 type can filter <id>:<mask> [<id>:<mask> ...]

would just be fine.

Wolfgang.
