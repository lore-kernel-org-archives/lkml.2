Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0KGPsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 10:48:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42828 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753309Ab0KGPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 10:48:16 -0500
Date: Sun, 7 Nov 2010 15:46:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sean Young <sean@mess.org>
Cc: David =?ISO-8859-14?B?SORyZGVtYW4=?= <david@hardeman.nu>,
        linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: Re: [PATCH] Fix Winbond CIR driver initialisation
Message-ID: <20101107154648.4bcdfb9f@lxorguk.ukuu.org.uk>
In-Reply-To: <20101107131825.GA40383@atlantis.8hz.com>
References: <20101107131825.GA40383@atlantis.8hz.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A workaround is to boot with argument 8250.nr_uarts=1. This is not really 
> desirable, so this patch makes ttyS1 go away.

setserial can also be used for this surely ?

> +		dev_info(device, "Unregistering phony serial port ttyS1\n");
> +		serial8250_unregister_port(1);
> +		ok = request_region(data->sbase, SP_IOMEM_LEN, DRVNAME);

That's a hack that is only going to work on specific systems where it is
mapped the way you expect and doing stuff behind the back of the serial
driver.

I'm not averse to a better solution but it needs to be general and
maintainable. Is there a way to identify the presence of the windbond CIR
device as opposed to an 8250 ?

Alan
