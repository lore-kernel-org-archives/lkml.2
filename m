Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1CQXsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:48:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36721 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981Ab1CQXsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:48:14 -0400
Date: Thu, 17 Mar 2011 23:48:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-serial@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] serial: 8250: Add a notifier chain for driver
 registration.
Message-ID: <20110317234814.421f1aa4@lxorguk.ukuu.org.uk>
In-Reply-To: <20110317193149.GD12824@angua.secretlab.ca>
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com>
	<1300325167-26433-2-git-send-email-ddaney@caviumnetworks.com>
	<20110317121849.49d7c425@lxorguk.ukuu.org.uk>
	<20110317182510.GN9597@angua.secretlab.ca>
	<4D82560B.4090800@caviumnetworks.com>
	<20110317184723.GQ9597@angua.secretlab.ca>
	<20110317192441.69c699b1@lxorguk.ukuu.org.uk>
	<20110317193149.GD12824@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Device registration isn't the problem.  The problem is supplying
> machine-specific callbacks from the board support code to the
> drivers.  When devices are sourced from a device tree, it is easy to
> get data about the device out of the tree, but it is really hard to
> get callback pointers.  To make it all work without this fiddling
> about, the octeon serial_{in,out} implementation would need to be
> rolled into of_serial.c (which FWIW, I have absolutely no problem
> with).

Disagree - the arch code needs to register I/O method descriptions with
the of_serial code they don't neccessarily need to be in it.

Ie you'd have something like

	of_serial8250_register_ops("dt-op-type-name-blah", &ops);

in the early boot code, and the ops can be in the arch, providing the ops
has a module owner field the rest can even work modular. Sure the stuff
should be able to describe standard forms directly without extra methods
being registered but for the special stuff I think that is the right
approach

Funnily enough I'm in the middle of trying to rip the rm9k, au and other
crap out of 8250.c by doing this for the UPIO_xxx ids and once you have
an ops struct you can also then go and boot out the resource claim crap
and package it all nicely.
