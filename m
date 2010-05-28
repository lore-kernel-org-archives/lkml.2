Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab0E1JrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:47:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39195 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754763Ab0E1JrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:47:18 -0400
Date: Fri, 28 May 2010 10:53:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tytso@mit.edu
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528105333.40a1efbe@lxorguk.ukuu.org.uk>
In-Reply-To: <20100528043114.GC26177@thunk.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted

As a PS to the previous email the situation has I think more choices than
you portray.

Given the need for various constraints imposed by drivers for things like
RT it's entirely possible that a solution ends up being something like


Kernel proper:
Turn suspend block kernel API into an expression of constraints (or
				whatever else seems to work)
Throw the user space in the bin

Google:
Use the constraints in a sledgehammer manner (hey it solves your problem
			in that form so why not)
Patch in a private user space API


That makes things much much easier as we don't risk getting a horribly
broken API into the kernel that is hard to remove, while hopefully
meaning its rather easier for google to merge drivers and other code as
well as to maintain a smaller patch set.

