Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1GEQ11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:27:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42050 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab1GEQ10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <201107051805.00696.arnd@arndb.de>
References: <20110704170949.11059.92774.stgit@ponder> <201107051721.02079.arnd@arndb.de>
 <20110705155040.GB16682@suse.de> <201107051805.00696.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 5 Jul 2011 10:27:05 -0600
X-Google-Sender-Auth: ygF7pk4LfQTeVH9boZe767FKwjE
Message-ID: <CACxGe6tGF5RBzaHe6TF1dqVs5hY9p809v5r07kWcguyA2Z8Yzw@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 10:05 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 05 July 2011, Greg KH wrote:
>> > * go through all initcalls, record any devices that are not yet ready
>> > * retry all devices on the list as long as at least one of them has
>> >   succeeded.
>> > * when a new device gets matched from a module load, do that loop again
>>
>> You don't know when init calls are finished, or if a module is loaded,
>> the driver core isn't that smart at all.
>
> We know when most initcalls are finished (at late_initcall time), and
> after that we don't need to know when a module gets loaded, only
> when a device gets matched, and that's something we do know and
> that Grant's patch uses already.

Yes, I'm thinking about doing exactly that.

>> > late_initcall(retry_devices);
>>
>> I wonder if doing this all from a workqueue in the first place is going
>> to cause problems as probe isn't normally done this way at all.

Problems with drivers or problems with the driver core?  It shouldn't
be a problem for drivers since only drivers that have explicitly
requested deferral will end up with the device added to the deferral
list.

> True. It will definitely cause problems for any driver that calls
> flush_work() in its probe function. We would need a private
> singlethread_workqueue to avoid that.

Ah, good point.  That's easy enough to do.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
