Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1CKOaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:30:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35877 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488Ab1CKOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:30:08 -0500
Date: Fri, 11 Mar 2011 14:30:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tty: serial: Use hub6_serial_X when
 CONFIG_SERIAL_8250_HUB6 is defined
Message-ID: <20110311143010.3aef5873@lxorguk.ukuu.org.uk>
In-Reply-To: <201103111456.15705.arnd@arndb.de>
References: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
	<20110311135024.400582fd@lxorguk.ukuu.org.uk>
	<201103111456.15705.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> or some variation of this. It's fine as long as this code never gets
> called, but incorrect nonetheless.

I disagree - the WARN(1) is certainly correct.

> I think it would be much cleaner if architectures that cannot do this
> would not have to define those functions and we could make sure that
> all drivers that do inb() have correct Kconfig dependencies.

For 8250 the way to do that is to remove all the switches and port type
stuff and propogate to setting ->serial_in and ->serial_out rather than
splattering the code with ifdefs. At that point you'd have a "lib8250" or
similar and an 8250_io/pci driver.

Alan
