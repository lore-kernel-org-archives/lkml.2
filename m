Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1GEQ27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:28:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63657 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab1GEQ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
References: <20110704170949.11059.92774.stgit@ponder> <20110704180159.GA11278@ponder.secretlab.ca>
 <20110705142149.GA3498@suse.de> <201107051721.02079.arnd@arndb.de>
 <20110705155040.GB16682@suse.de> <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 5 Jul 2011 10:28:37 -0600
X-Google-Sender-Auth: reXUA3BOedJVUHKkG6u9uvk08Vs
Message-ID: <CACxGe6sypBwP6aKoaxq1ipoEfqvnqq2RMhi9d0KU=LHjJm9x_g@mail.gmail.com>
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
>
> We have sync hooks (BUS_NOTIFY_*) where any kind of code can subscribe
> to when devices get added or get bound to a driver. Can't the code
> that relies on later hookups to already existing devices/bindings not
> just plug into that?

I tried that.  It resulted in a lot of complexity that each driver
needs to implement correctly which is why I started looking for a
different way to go about it.

g.
