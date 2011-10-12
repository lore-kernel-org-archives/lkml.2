Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1JLL6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 07:58:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37095 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752747Ab1JLL6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 07:58:50 -0400
Date: Wed, 12 Oct 2011 12:56:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Allen Martin <AMartin@nvidia.com>,
        Tom Warren <twarren@nvidia.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/serial: Prevent drop of DCD on suspend for Tegra
 UARTs
Message-ID: <20111012125647.6b9ec66e@lxorguk.ukuu.org.uk>
In-Reply-To: <1318377943-24519-1-git-send-email-dianders@chromium.org>
References: <1318377943-24519-1-git-send-email-dianders@chromium.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NOTE: If we have people that are using UARTA on a Tegra and need to
> control DTR, we'll need to either add a separate port type for UARTA
> or we'll need to add some tegra-specific code to detect whether the
> DTR needs to be left high.

I have two problems with this change

- It adds more special cases into the 8250.c core code
- It breaks the UARTA port (which is a regression so not acceptable for
  upstream merging)

I think you should simply provide your platform with an appropriate
serial_in/serial_out method that does the needed masking. That way its
kept isolated from everyone else.

Alan
