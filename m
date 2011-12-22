Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1LVFV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:21:56 -0500
Received: from mail.lang.hm ([64.81.33.126]:57951 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab1LVFVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:21:52 -0500
Date: Wed, 21 Dec 2011 21:21:32 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brian Swetland <swetland@google.com>
cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
In-Reply-To: <CANqkERDwpVqnYsC_0kQSyVohcoFK1vCEjXe+CwgdpMcNdKTkLQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1112212114590.28597@asgard.lang.hm>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de> <4EF27B85.9080801@am.sony.com> <20111222005114.GA22541@suse.de> <4EF288B4.1070601@am.sony.com> <20111222014718.GA13085@suse.de> <4EF29217.7040408@am.sony.com> <20111222034717.GB14174@suse.de>
 <CAPXgP10ikqHFn41wc1HPsKHyaC7fe1WGC2eHqs-hdRaZ7XCTLw@mail.gmail.com> <CANqkERCcciVxybh=66K5xxzzGmgw=fg0vwmcitWZ1y=DTxxtOA@mail.gmail.com> <alpine.DEB.2.02.1112212044240.28597@asgard.lang.hm>
 <CANqkERDwpVqnYsC_0kQSyVohcoFK1vCEjXe+CwgdpMcNdKTkLQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Brian Swetland wrote:

> The rate at which apps push data into logs is pretty amazing at times.
> The system booting (maybe 10-20 services and 10+ apps starting up)
> can blow through 256K of ringbuffer in seconds.

a smidge more information here.

256K of logs in 'seconds'

are we talking single digit seconds, tens of seconds, what?

any idea the average message size

on my server farms, the average log size is ~256 byttes, so if this was 
over 10 seconds we would be talking ~100 logs/sec. "slow" syslog daemons 
can handle this sort of load trivially, they start to take significant 
amounts of CPU (10%+) around two orders of magnatude higher data rates.

now, it may be that  the logs on the android are smaller, and you hit the 
256K injust a couple of seconds, at which point things would be a little 
harder, but since the job is so much simpler it shouldn't be that hard.

David Lang

