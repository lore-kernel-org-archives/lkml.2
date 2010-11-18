Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455Ab0KRU76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:59:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48636 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760409Ab0KRU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:59:57 -0500
Date: Thu, 18 Nov 2010 20:58:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118205847.11485945@lxorguk.ukuu.org.uk>
In-Reply-To: <4CE58005.7040308@freescale.com>
References: <20101118022434.GA9833@suse.de>
	<4CE546C5.8060401@freescale.com>
	<20101118153912.GA1443@suse.de>
	<4CE54E40.9040503@freescale.com>
	<20101118163321.GA2723@suse.de>
	<4CE5562B.8080604@freescale.com>
	<20101118165136.GA3103@suse.de>
	<4CE55ACB.80207@freescale.com>
	<20101118171856.GA4283@suse.de>
	<4CE5647F.5000203@freescale.com>
	<20101118175832.GA4931@suse.de>
	<4CE58005.7040308@freescale.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> for (i = 0; i < num_byte_channels; i++) {
> 	bc->handle = get_the_byte_channel_handle(i);
> 	ehv_bc_driver->name_base = bc->handle - i;
> 	tty_register_device(ehv_bc_driver, i, NULL);
> }
> 
> This actually works and does what I want, but I seriously doubt it's acceptable.
>  When I do this, I get:
> 
> # ls -l /dev/ttyEH*
> crw-rw----    1 root     uucp     253,   0 Jan  1 00:00 /dev/ttyEHV73
> crw-rw----    1 root     uucp     253,   1 Jan  1 00:00 /dev/ttyEHV76
> crw-rw----    1 root     uucp     253,   2 Jan  1 00:00 /dev/ttyEHV79

Which looks the right approach to me.

