Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2E1Sjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:39:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46649 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab2E1Sj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:39:27 -0400
Date: Mon, 28 May 2012 19:39:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH] serial/of-serial: Add 16654 chip to compatible string
	list
Message-ID: <20120528183913.GD28290@n2100.arm.linux.org.uk>
References: <1338199134-23885-1-git-send-email-stigge@antcom.de> <20120528100338.GI24149@n2100.arm.linux.org.uk> <4FC35F97.2030400@antcom.de> <20120528150311.GA28290@n2100.arm.linux.org.uk> <4FC3A768.3060208@antcom.de> <20120528163151.GB28290@n2100.arm.linux.org.uk> <4FC3BA89.4060804@antcom.de> <20120528180139.GC28290@n2100.arm.linux.org.uk> <4FC3C156.5040609@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC3C156.5040609@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 08:17:58PM +0200, Roland Stigge wrote:
> On 28/05/12 20:01, Russell King - ARM Linux wrote:
> >> Now, introducing a new type, can I add to 8250.c's uart_config[] by
> >> introducing a new type (no. 22) after PORT_XR17D15X? Unfortunately,
> >> there are the "ARM specific type numbers" after current PORT_MAX_8250
> >> (21), but those are not listed in 8250.c's uart_config[]. Or how am I
> >> supposed to add a new type?
> > 
> > If it's 8250, stick it in with the group, otherwise the array will
> > become stupidly large.  That's why there's a separation of the two.
> 
> Do you mean adding one element to uart_config[] and increasing
> PORT_MAX_8250 (actually, the size of uart_config[]) by one? I would also
> need to increase the indices of all the following "ARM specific type
> numbers" by one (the second group).

#define PORT_XR17D15X   21      /* Exar XR17D15x UART */
#define PORT_MAX_8250   21      /* max port ID */

#define PORT_PXA        31

There's space between 21 and 31...
