Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1EKVox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:44:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab1EKVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:44:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Wed, 11 May 2011 23:44:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, "open list" <linux-kernel@vger.kernel.org>,
        "CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <2BFFDAA0A0DE4820876E5549867938EC@subhasishg> <201105112331.47954.arnd@arndb.de>
In-Reply-To: <201105112331.47954.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112344.44171.arnd@arndb.de>
X-Provags-ID: V02:K0:PDVjE9FpOO9jh+zrWcbGf5EMcWIgoBgmyJ8fMTmnZfF
 n30tyR5L2JVOSUbgkVF8CFm692s49EKI3dh3qo+L6dhypB4hbP
 0Tw5QtDuMJQfz1LTBb/InyCGHXRimXlDdEUikFuXs9aPJBapGa
 1TA3QVS9h0bBiTQW/lJkqJOvzuVfwCxok8AsdlF5DjxgOA47El
 SCkTKsYEF76aDfOlWgE6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 May 2011, Arnd Bergmann wrote:
> If that interpretation is right, I would seriously recommend rethinking
> the design of the CAN firmware for pruss, so you can start doing something
> useful with the offload engine that fits into the Socket CAN API, or that
> would be a useful extension to Socket CAN that is also implementable in
> the kernel for all other drivers in a meaningful way.

I've looked some more into the CAN socket implementation, and I suppose that
the idea of the pruss driver was really to help do the work from the
can_rcv_filter function in hardware.

Doing this right would really mean supporting both a mode where any new
filter that gets added to socket can ends up being added to the hardware
as long as it fits, similar to how we can add additional unicast mac
addresses to an ethernet NIC. However, when the filters from all user
sockets combined can not be represented in the hardware driver, the hardware
needs to be put into a less efficient mode where all packets are returned
to the kernel and processed in software.

	Arnd
