Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2CKSXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 14:23:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40279 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2CKSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 14:23:06 -0400
Date: Sun, 11 Mar 2012 18:24:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: santosh prasad nayak <santoshprasadnayak@gmail.com>,
        FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Video : Amba: Use in_interrupt() in clcdfb_sleep().
Message-ID: <20120311182457.29d3e42c@pyramind.ukuu.org.uk>
In-Reply-To: <20120311154846.GD13336@n2100.arm.linux.org.uk>
References: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120311132746.GA13336@n2100.arm.linux.org.uk>
	<CAOD=uF7kQHABCmxUL3-J-hZ1E2mXrb7dgsYq7msHhiPJ4Gm-Ew@mail.gmail.com>
	<20120311143615.GB13336@n2100.arm.linux.org.uk>
	<CAOD=uF5GbsyHS5iXjJ1YcqJyGLHwT8Wjhiie1daJAVqu527Umg@mail.gmail.com>
	<20120311150311.GC13336@n2100.arm.linux.org.uk>
	<CAOD=uF5F4tOG0Y2tZdDeMgqs4-46HXYzA3RR-t8KuNuYRarJbg@mail.gmail.com>
	<20120311154846.GD13336@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As I've said, if we aren't going to use this, then the only solution is
> to completely omit the msleep() there and just say "sod you to running
> anything else for 20ms while this driver busy-spins."  That's
> ultimately the safe thing to do, and at the moment I see no other
> alternative there.

Anyone having this argument is also right now peeing into the wind. Quite
a few console drivers do this including some the big name x86 ones. We
don't seem to be getting any resulting problem reports.

Architecturally we really need a way to help console drivers separate the
civilised acceleration friendly, lock friendly output paths from printk.
That's the real fix, but a whole different matter to solve cleanly.

Alan
