Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab1GERgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:36:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44900 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1GERf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110705172903.GB1155@suse.de>
References: <20110704170949.11059.92774.stgit@ponder> <20110704180159.GA11278@ponder.secretlab.ca>
 <20110705142149.GA3498@suse.de> <201107051721.02079.arnd@arndb.de>
 <20110705155040.GB16682@suse.de> <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
 <CACxGe6sypBwP6aKoaxq1ipoEfqvnqq2RMhi9d0KU=LHjJm9x_g@mail.gmail.com>
 <20110705163628.GB31984@suse.de> <CACxGe6v_HVWcci2cPDyNALWST0E3_iXWZzrhi49e_cUX1VCt+Q@mail.gmail.com>
 <20110705172903.GB1155@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 5 Jul 2011 11:35:37 -0600
X-Google-Sender-Auth: 9CM7CquyZqhDTJIE7JzrbK5EZJI
Message-ID: <CACxGe6u4CaJj+pGmRbqSqT18ATsU3-h0+1mELThfxt6cpLmEaQ@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 11:29 AM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Jul 05, 2011 at 11:17:46AM -0600, Grant Likely wrote:
>> On Tue, Jul 5, 2011 at 10:36 AM, Greg KH <gregkh@suse.de> wrote:
>> > On Tue, Jul 05, 2011 at 10:28:37AM -0600, Grant Likely wrote:
>> >> On Tue, Jul 5, 2011 at 10:11 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> >> > On Tue, Jul 5, 2011 at 17:50, Greg KH <gregkh@suse.de> wrote:
>> >> >
>> >> >> I wonder if doing this all from a workqueue in the first place is going
>> >> >> to cause problems as probe isn't normally done this way at all.
>> >> >
>> >> > Yeah, I would expect unforeseen problems with the async thread too.
>> >> > It's probably all solvable, but it sounds troublesome to find out if
>> >> > things go wrong.
>> >> >
>> >> > We have sync hooks (BUS_NOTIFY_*) where any kind of code can subscribe
>> >> > to when devices get added or get bound to a driver. Can't the code
>> >> > that relies on later hookups to already existing devices/bindings not
>> >> > just plug into that?
>> >>
>> >> I tried that.  It resulted in a lot of complexity that each driver
>> >> needs to implement correctly which is why I started looking for a
>> >> different way to go about it.
>> >
>> > No, the bus that wants this just has to do it, not the drivers
>> > themselves, right?
>>
>> It's not about the bus_type, and there is nothing that the bus can do
>> to solve this problem because it the dependencies are completely
>> orthogonal to the bus.  ie. what does an i2c bus know about the audio
>> path to a codec?  The problem must be solved at the driver scope.
>
> Ok, let's look at your next implementation and see how it goes.

Okay, thanks.  I'll get it posted soon.

g.
