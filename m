Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1EKVb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:31:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab1EKVb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:31:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Wed, 11 May 2011 23:31:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, "open list" <linux-kernel@vger.kernel.org>,
        "CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <20110510112734.54160824@lxorguk.ukuu.org.uk> <2BFFDAA0A0DE4820876E5549867938EC@subhasishg>
In-Reply-To: <2BFFDAA0A0DE4820876E5549867938EC@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112331.47954.arnd@arndb.de>
X-Provags-ID: V02:K0:1cUffEci5eAr1n9bRXI1rt7oczcD8bk+vBT/T0+N7dV
 q4REjdmgTDtKjH2FyLktWA/RG2bZCBL3L3nDuodmePRv4U5bw/
 e/sk8PYGsKex/20r8+mHR9SdwEWcCpghNJR8I6SWQfFdRKXzaj
 bYjXvYbNm9RX1fCQoweVV0XDZxBxaRlCqZGCG43a7mR6JtM67e
 HMvIh8sYh6aVQOnWs5KPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 May 2011, Subhasish Ghosh wrote:
> 
> >> Yes, In case if we allow the ALL implementation, it hogs the CPU.
> >> In that case we do not need the PRU. The whole purpose of the PRU
> >> is to offload the processor for any such implementations. 
> > 
> > So the kernel presumably needs to switch between using the PRU and native
> > according to the number of ids being requested at the time ?
> 
> All the IDs are programmed into the PRU data RAM.
> The Kernel receives interrupts based upon these IDs.
> I could not clearly follow "PRU and native", could you please elaborate.

We would really like all CAN drivers to behave the same way. All other
drivers are able to work without filters, so pruss_can should allow that
too, even if it becomes a CPU hog at that time.

It seems to me that the pruss can implementation has one thing backwards:
it assumes a specific usage model for CAN that it is trying to do offload
for. However, that usage model is currently not even supported by Socket
CAN. If I understand Wolfgang correctly, it is in fact considered an
unwanted limitation of the pruss can driver, instead of a useful feature.

If that interpretation is right, I would seriously recommend rethinking
the design of the CAN firmware for pruss, so you can start doing something
useful with the offload engine that fits into the Socket CAN API, or that
would be a useful extension to Socket CAN that is also implementable in
the kernel for all other drivers in a meaningful way.

	Arnd
