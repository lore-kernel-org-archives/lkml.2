Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1GEQLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:11:35 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56754 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1GEQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110705155040.GB16682@suse.de>
References: <20110704170949.11059.92774.stgit@ponder> <20110704180159.GA11278@ponder.secretlab.ca>
 <20110705142149.GA3498@suse.de> <201107051721.02079.arnd@arndb.de> <20110705155040.GB16682@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 5 Jul 2011 18:11:14 +0200
Message-ID: <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Greg KH <gregkh@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 17:50, Greg KH <gregkh@suse.de> wrote:

> I wonder if doing this all from a workqueue in the first place is going
> to cause problems as probe isn't normally done this way at all.

Yeah, I would expect unforeseen problems with the async thread too.
It's probably all solvable, but it sounds troublesome to find out if
things go wrong.

We have sync hooks (BUS_NOTIFY_*) where any kind of code can subscribe
to when devices get added or get bound to a driver. Can't the code
that relies on later hookups to already existing devices/bindings not
just plug into that?

Thanks,
Kay
