Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab1CDMny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:43:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46505 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759525Ab1CDMnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:43:53 -0500
Date: Fri, 4 Mar 2011 12:43:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304124348.6419c661@lxorguk.ukuu.org.uk>
In-Reply-To: <20110303222226.GA30966@kroah.com>
References: <20110303204749.GY3663@linux.intel.com>
	<20110303211336.GA32645@kroah.com>
	<20110303214104.GZ3663@linux.intel.com>
	<20110303215155.GA30451@kroah.com>
	<20110303220735.GA3663@linux.intel.com>
	<20110303222226.GA30966@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 14:22:26 -0800
> > How would the driver know that it should call request_firmware()?
> > Do it every 60 seconds in case somebody's downloaded some new firmware?
> 
> Ick, no, just use the function provided that lets you create a firmware
> request and be notified when it is written to,
> request_firmware_nowait().  That is what it is there for.

Bunkum

It's there for automated loading of needed firmware

> Anyway, just use request_firmware_nowait(), you will be fine.

Not really. You've got no way with the request_firmware interface for the
user space and kernel space to reliably time objects together eg to do
user side work before a firmware load.

Almost all the other stuff in the kernel which is for firmware
programming as opposed to automatic loading is not using request_firmware
- and for good reasons like needing to be able to specify the path to the
object reliably - which cannot be done with namespaces.

>From a security perspective, a correctness perspective, for reliability
and managability request_firmware is the wrong interface for flashing new
firmware.

Alan
