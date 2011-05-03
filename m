Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1ECNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:34:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47637 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750862Ab1ECNeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:34:10 -0400
Date: Tue, 3 May 2011 14:35:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, jimmy.chen@moxa.com,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        wim@iguana.be
Subject: Re: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog
 driver
Message-ID: <20110503143501.2596a9ce@lxorguk.ukuu.org.uk>
In-Reply-To: <201105031451.56911.arnd@arndb.de>
References: <20110503103704.69aba5b2@lxorguk.ukuu.org.uk>
	<20110503105735.GB2497@pengutronix.de>
	<20110503121510.5bba70c5@lxorguk.ukuu.org.uk>
	<201105031451.56911.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another thing that might be nice here is to have one module that probes
> the superio-port and then registers a platform device that other drivers

That doesn't help. See the it87 request_muxed patches pending. Because
the port can be muxed we need to actually implement port muxing across
the super I/O devices. That's a separate and larger problem altogether
and this device will get fixed as we do the other so not a problem.

> can can bind to. Right now, you have to load the module manually and
> then check if it's there, something we no longer do for most devices.

A lot of these super I/O devices have no entirely safe autodetect, and
the same is true for it87 and many others. There isn't a nice elegant
solution really.

Alan
