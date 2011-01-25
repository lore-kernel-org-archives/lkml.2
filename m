Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1AYHtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:49:49 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:11030 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1AYHts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:49:48 -0500
Date: Tue, 25 Jan 2011 08:49:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/staging/lirc: Remove obsolete cleanup for 
 clientdata
Message-ID: <20110125084930.6d87161a@endymion.delvare>
In-Reply-To: <1295914142.2420.29.camel@localhost>
References: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
	<1295865880-27672-4-git-send-email-w.sang@pengutronix.de>
	<1295914142.2420.29.camel@localhost>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 19:09:02 -0500, Andy Walls wrote:
> On Mon, 2011-01-24 at 11:44 +0100, Wolfram Sang wrote:
> > A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> > on exit or error. This is obsolete meanwhile, the core will do it. Simplify the
> > kfree() calls after that, the pointers don't need to be checked.
> > 
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Cc: Andy Walls <awalls@md.metrocast.net>
> 
> Nak.
> 
> In a module where I plan to do more cleanup and add reference counting
> to struct IR, IR_tx, and IR_rx objects, I'd like the explicit "NULL"s in
> pointer checks to stay in for now.
> 
> Removing the explicit constant "NULL" makes searching for checks against
> NULL pointers more difficult when auditing the code (No red syntax
> highlighting and a /NULL search misses).

I agree that Wolfram was too generous with his clean-ups this time.
Wolfram, you should only be removing the calls to i2c_set_clientdata(x,
NULL), not changing the logic of the code.

Furthermore, lirc_zilog is currently undergoing heavy changes, I'd
rather let Andy and Jarod work on that staging driver, and clean up
what needs to be later.

-- 
Jean Delvare
