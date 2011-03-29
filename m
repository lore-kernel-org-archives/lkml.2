Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1C2L7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:59:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53006 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249Ab1C2L7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:59:13 -0400
Date: Tue, 29 Mar 2011 12:59:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Waldemar.Rymarkiewicz@tieto.com, sameo@linux.intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, matti.j.aaltonen@nokia.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110329125931.21a69776@lxorguk.ukuu.org.uk>
In-Reply-To: <201103291305.02293.arnd@arndb.de>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<20110325142648.GC3879@sortiz-mobl>
	<99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
	<201103291305.02293.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The difference between the two is where you keep the common
> NFC logic:

I think I'd disagree on that
> 
> If you have a character device, it will be like a serial port
> connecting to a modem. Any higher-level protocols live in the
> user space and are limited to a single application then, which
> is required to have appropriate priviledges to open the device.

A socket is just an API just as a file, you can put the stack in either
place in either case.

> character device is its simplicity, so that would be preferred
> if you only expect a very small set of possible applications
> for this.

NFC is not particularly performance dependant so having a lot of the
stack in a daemon isn't really going to hurt anything too much on a
client embedded device/phone.

The bigger question is probably what it needs to look like the other end
- ie the server side embedded devices doing transactions.
