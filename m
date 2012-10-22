Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2JVOeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:34:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48759 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2JVOea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:34:30 -0400
Date: Mon, 22 Oct 2012 15:39:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Guido =?ISO-8859-1?B?R/xudGhlcg==?= <agx@sigxcpu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Black screen with gma500_gfx on 3.6.2
Message-ID: <20121022153936.455ac8f8@pyramind.ukuu.org.uk>
In-Reply-To: <20121021115625.GA2535@bogon.sigxcpu.org>
References: <20121021115625.GA2535@bogon.sigxcpu.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  689.950596] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
> [  689.950627] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0

It's got the LVDS configured it seems and the brightness was already set
up. That should be harmless.

> Besides the VGA the driver detects a LVDS as well although there's none
> attached (the board does have a connector for it though):

Ok so it finds both ports which is what I would expect

> # grep -l ^connected /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-*/status
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/status
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-VGA-1/status

This means it found there was a VGA port and from
psb_intel_sdvo_output_setup called psb_intel_sdvo_analog_init.

> 
> It also states that both ports are disabled:

Which would explain the black screen.

> 
> # cat   /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-*/enabled
> disabled
> disabled
> 
> I didn't find a way to enable any of these ports via sysfs and X.org's
> modesetting driver fails either. Any pointers on howto debug this
> further are greatly appreciated.

My first guess would be that the detection of the VGA failed. That would
explain all your symptoms and since it relies on the firmware...

First thing to do is turn drm debug on in full and you should then get a
dump of the SDVO capabilities, particulary output_flags as well as an
entry giving the clock range etc if it initialized it ok.

Alan
