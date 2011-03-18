Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1CRFSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 01:18:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46789 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab1CRFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 01:18:47 -0400
Date: Thu, 17 Mar 2011 23:18:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-serial@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] serial: 8250: Add a notifier chain for driver
 registration.
Message-ID: <20110318051844.GF18545@angua.secretlab.ca>
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com>
 <1300325167-26433-2-git-send-email-ddaney@caviumnetworks.com>
 <20110317121849.49d7c425@lxorguk.ukuu.org.uk>
 <20110317182510.GN9597@angua.secretlab.ca>
 <4D82560B.4090800@caviumnetworks.com>
 <20110317184723.GQ9597@angua.secretlab.ca>
 <20110317192441.69c699b1@lxorguk.ukuu.org.uk>
 <20110317193149.GD12824@angua.secretlab.ca>
 <20110317234814.421f1aa4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317234814.421f1aa4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:48:14PM +0000, Alan Cox wrote:
> > Device registration isn't the problem.  The problem is supplying
> > machine-specific callbacks from the board support code to the
> > drivers.  When devices are sourced from a device tree, it is easy to
> > get data about the device out of the tree, but it is really hard to
> > get callback pointers.  To make it all work without this fiddling
> > about, the octeon serial_{in,out} implementation would need to be
> > rolled into of_serial.c (which FWIW, I have absolutely no problem
> > with).
> 
> Disagree - the arch code needs to register I/O method descriptions with
> the of_serial code they don't neccessarily need to be in it.
> 
> Ie you'd have something like
> 
> 	of_serial8250_register_ops("dt-op-type-name-blah", &ops);
> 
> in the early boot code, and the ops can be in the arch, providing the ops
> has a module owner field the rest can even work modular. Sure the stuff
> should be able to describe standard forms directly without extra methods
> being registered but for the special stuff I think that is the right
> approach

Yeah, okay.  That's nice and clean.  I like it.

> Funnily enough I'm in the middle of trying to rip the rm9k, au and other
> crap out of 8250.c by doing this for the UPIO_xxx ids and once you have
> an ops struct you can also then go and boot out the resource claim crap
> and package it all nicely.

:-)

g.
