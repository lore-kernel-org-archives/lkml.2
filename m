Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1ADN5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:57:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51368 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897Ab1ADN5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:57:30 -0500
Date: Tue, 4 Jan 2011 13:56:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Williamson <michael.williamson@criticallink.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, khilman@deeprootsystems.com,
        linux-serial@vger.kernel.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: Provide capability to disable modem status
 interrupts in 8250 driver
Message-ID: <20110104135621.56a4770e@lxorguk.ukuu.org.uk>
In-Reply-To: <1294149062-31173-1-git-send-email-michael.williamson@criticallink.com>
References: <1294149062-31173-1-git-send-email-michael.williamson@criticallink.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch was tested using a MityDSP-L138F platform having a UART CTS pin
> connected to a clock signal (and configured, via pinmux, as a clock input
> for another peripheral function).

Please hide such horrors in your platform code. We are trying todrive all
the quirks stuff we can out of the core code.

Instead provide your own I/O methods when registering the port and mask
the appropriate bogus bits in the register.

