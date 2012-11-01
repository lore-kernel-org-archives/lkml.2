Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464Ab2KANq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:46:57 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34630 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761439Ab2KANqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:46:53 -0400
Date: Thu, 1 Nov 2012 13:51:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: <balbi@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121101135148.382aec00@pyramind.ukuu.org.uk>
In-Reply-To: <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
References: <20121031212639.GQ12739@atomide.com>
	<8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
	<20121031221402.GA29490@arwen.pp.htv.fi>
	<E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com>
	<50924DA3.1060901@ti.com>
	<F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
	<20121101110418.GF410@arwen.pp.htv.fi>
	<3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
	<20121101124025.GA12489@arwen.pp.htv.fi>
	<A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
	<20121101131609.GC12489@arwen.pp.htv.fi>
	<E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What they want, and what every user wants, is I plug this board in, and
> the driver make sure everything is loaded and ready. No, the end users
> don't want to see any of the implementation details of how the bitfile
> is transported; the driver can handle it.

That doesn't necessarily make it a bus merely some kind of hotplug
enumeration of devices. That should all work properly both for devices
and busses with spi and i²c as the final bits needed for it got fixed
some time ago.

In an ideal world you don't want to be writing custom drivers for stuff.
If your cape routes an i²c serial device to the existing system i²c
busses then you want to just create an instance of any existing driver on
the existing i²c bus not create a whole new layer of goop.

It does need to do the plumbing and resource management for the plumbing
but thats not the same as being a bus.

Alan
