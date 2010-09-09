Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0IIO1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:27:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35453 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753924Ab0IIO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:27:49 -0400
Date: Thu, 9 Sep 2010 15:47:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Stephane Grosjean" <grosjean@iphase.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: tty_buffer_request_room() vs. ppp_sync_input(): a
 single  buffer may contains several frames
Message-ID: <20100909154757.075f675a@lxorguk.ukuu.org.uk>
In-Reply-To: <0D81855AB9880044B3FD8FE8A7B520595B040D@EXMAIL.interphase.iphase.com>
References: <0D81855AB9880044B3FD8FE8A7B520595B040D@EXMAIL.interphase.iphase.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My problem is that the "tty_buffer_request_room()" function may use the
> same buffer (the tail) if it finds enough place to store the incoming
> frame in.

Correct. The tty layer doesn't preserve record boundaries.

> Please let me know if I'm right and if this fix is the only way to pass
> synchronous frames to upper layers.

The tty buffer system is not intended for framed data. It doesn't handle
all sorts of cases of it and will split buffers and pack them as it sees
fit.

There is a limited provision for tty style handling of such interfaces
because some hardware is dual mode but it requires you don't use the tty
buffering helpers.

If your hardware is a straight sync board you probably want to look at
drivers/net/wan/hdlc*c which provides the interfaces so you can just
throw frames straight off a card into the network layer and appear as a
network stack. Unlike n_syncppp it also supports other protocols pretty
much for free (Cisco HDLC etc)

Alan
