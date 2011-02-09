Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1BIKk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:40:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34462 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618Ab1BIKk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:40:56 -0500
Date: Wed, 9 Feb 2011 10:43:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH RESENT#2] [AVR32] don't check platform_get_irq's return
 value against zero
Message-ID: <20110209104310.71c12826@lxorguk.ukuu.org.uk>
In-Reply-To: <1297247284-31650-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288690250.32331.41.camel@hcegtvedt>
	<1297247284-31650-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 11:28:04 +0100
Uwe Kleine-König  <u.kleine-koenig@pengutronix.de> wrote:

> platform_get_irq returns -ENXIO on failure, so !int_irq was probably
> always true.  Better use (int)int_irq <= 0.  Note that a return value of
> zero is still handled as error even though this could mean irq0.

We don't have an IRQ 0 in Linux so that's fine.
