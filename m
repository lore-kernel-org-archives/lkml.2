Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1GEQdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:33:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44932 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1GEQdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
References: <20110704170949.11059.92774.stgit@ponder> <20110704180159.GA11278@ponder.secretlab.ca>
 <20110705142149.GA3498@suse.de> <201107051721.02079.arnd@arndb.de>
 <20110705155040.GB16682@suse.de> <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 5 Jul 2011 10:33:15 -0600
X-Google-Sender-Auth: kx-8xw7SCYwVnIFrTL4EpW6j5-E
Message-ID: <CACxGe6seKN4Z-wBgTuZjr9=yP6y8f7YJ1Ah=ORq18-QUSXO1Nw@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 10:11 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Jul 5, 2011 at 17:50, Greg KH <gregkh@suse.de> wrote:
>
>> I wonder if doing this all from a workqueue in the first place is going
>> to cause problems as probe isn't normally done this way at all.
>
> Yeah, I would expect unforeseen problems with the async thread too.
> It's probably all solvable, but it sounds troublesome to find out if
> things go wrong.

I think it is worth solving though since the feature is important.  I
can certainly block out the deferral code with a Kconfig symbol so
that it only gets built when a driver selects CONFIG_PROBE_DEFERRAL.
That would keep the code out of x86 kernels while us embedded folks
iron out the bugs.

g.
