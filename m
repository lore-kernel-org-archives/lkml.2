Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab2ARWMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:12:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53170 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2ARWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:12:23 -0500
Date: Wed, 18 Jan 2012 22:12:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
Message-ID: <20120118221255.5c14f382@pyramind.ukuu.org.uk>
In-Reply-To: <CAPnjgZ1GJatR15dVsq-+hAWhD7eaLhtN737QvBaor_=0+K+6wA@mail.gmail.com>
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
	<1326826563-32215-3-git-send-email-sjg@chromium.org>
	<20120117201036.6d99f98f@pyramind.ukuu.org.uk>
	<20120118041720.GA2431@linux.vnet.ibm.com>
	<CAPnjgZ1GJatR15dVsq-+hAWhD7eaLhtN737QvBaor_=0+K+6wA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Let me provide a bit of context. The serial_core code seems to be the
> only place in the kernel that does this:
> 
> 		device_init_wakeup(tty_dev, 1);
> 		device_set_wakeup_enable(tty_dev, 0);
> 
> The first call makes the device wakeup capable and enables wakeup, The
> second call disabled wakeup.

> I assume we can't and shouldn't change device_init_wakeup() . We could
> add a call like device_init_wakeup_disabled() which makes the device
> wakeup capable but does not actually enable it. Does that work?

Is that not

	device_init_wakeup(tty_dev, 0)

or am I missing something ?
