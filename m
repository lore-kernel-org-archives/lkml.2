Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1KNL4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 06:56:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:17424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1KNL4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 06:56:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="75053586"
Date: Mon, 14 Nov 2011 12:07:45 +0000
From: Alan Cox <alan@linux.intel.com>
To: Darron Black <darron@griffin.net>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some
 variables
Message-ID: <20111114120745.376729c4@bob.linux.org.uk>
In-Reply-To: <4EC062B7.2090100@griffin.net>
References: <4E492CFF.7040905@pwrnet.de>
	<20110822211832.GA8023@kroah.com>
	<4EB3A009.10502@evidence.eu.com>
	<4EB8F6B9.6010008@atmel.com>
	<4EB90902.4030200@evidence.eu.com>
	<20111108134804.07095c5d@lxorguk.ukuu.org.uk>
	<20111108142432.GA11293@kroah.com>
	<4EBA9385.7010806@evidence.eu.com>
	<20111113215318.GA2966@pengutronix.de>
	<4EC062B7.2090100@griffin.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps the RTS toggle after transmit delay needs to be large, and 
> they'd rather do it in userspace than block in the driver. I also
> recall a protocol that would send a master assertion command and hold
> on to RTS afterwards. I can easily imagine needing to quickly

Appletalk does this for one. Some protocols use it for priming low cpu
power receivers. You fire a header message at the target which fits
into its serial fifo, it then responds and can sit in a tight loop
getting the following frame data.

Alan
