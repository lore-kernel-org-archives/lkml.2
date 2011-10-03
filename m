Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1JCKHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:07:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48720 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754255Ab1JCKHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:07:02 -0400
Date: Mon, 3 Oct 2011 11:06:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Doron Cohen" <doronc@siano-ms.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: How can LKM store persistent data?
Message-ID: <20111003110601.127f3043@lxorguk.ukuu.org.uk>
In-Reply-To: <D945C405928A9949A0F33C69E64A1A3BCD3DB9@s-mail.siano-ms.ent>
References: <D945C405928A9949A0F33C69E64A1A3BCD3DB9@s-mail.siano-ms.ent>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Our device has some configuration data like DVB standard and operation
> mode which is not changes frequently. Currently it can be changed using
> module parameters and by ioctl calls. But when the driver is down and up
> again (meaning - every restart, sleep, reboot etc.)  the module is back

Shouldn't be every sleep - you can reload across a suspend/resume
yourself simply by remembering the module settings in the driver.

> Our users asked us to keep this data persistent, if someone is using
> ISDBT he would probably use it forever unless traveling to another
> region. So the request is once a mode was set, do not change it on the
> next reload just work at that mode until instructed otherwise. Therefore
> the driver needs to save this data somehow, and read it when it loads
> and work according to it.

The usual way is to load the settings when the driver is loaded. udev has
rules for what to do on driver loads (create things, configure stuff etc)
so you can use a udev rule to run a program on driver load which loads
the settings.

Saving them in userspace so the udev app can reload them is then up to
your configuration tool/apps.

Alan
