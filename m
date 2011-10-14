Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1JNTHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:07:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52012 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1JNTHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110141432070.2036-100000@iolanthe.rowland.org>
References: <CACxGe6sc8qOWDvLYSKwUzG8-VEZCXDKQX88qQsFYuP2QtEHvFg@mail.gmail.com>
 <Pine.LNX.4.44L0.1110141432070.2036-100000@iolanthe.rowland.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Oct 2011 13:07:21 -0600
X-Google-Sender-Auth: fW6K7I3w6tAHnpItgEY7A2fbWws
Message-ID: <CACxGe6uvw9NJ0WYwU90LCdfz-xx4ZLoeGX4vZhFQCRvs1aMDdw@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 12:39 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 14 Oct 2011, Grant Likely wrote:
>> I'd be much happier to find a way to do this in core code though.  And
>> there is still a potential race condition here.  For example, if G is
>> in the middle of it's probe routine, and D gets probed between G
>> registering GPIOs and calling dpm_move_last(), then we're in the same
>> boat again.
>
> Of course, this means that G must call dpm_move_last() _before_
> registering its GPIOs.  So the overall flow of a probe routine is
> simple enough:
>
>        1. Check that all the resources you need are available.
>
>        2. If not, defer your probe.  If yes, call dpm_move_last().
>
>        3. Finish the probe, including registration of resources
>           that will be available to other drivers (such as child
>           devices).

Alright, let's start with this.  That also means that the current
probe deferral patch doesn't need to have any knowledge of dpm_list
added to it.  It will be required only of the users.

I'd still like to look closely at the ordering of dpm_list for the
non-deferred use case, but that can be an entirely separate patch set.
 It doesn't need to block the probe deferral work.

g.
