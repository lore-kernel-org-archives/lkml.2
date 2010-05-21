Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0EUNzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:55:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40590 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0EUNzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <201005211909.29326.knikanth@suse.de>
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> 
	<AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> 
	<201005211909.29326.knikanth@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 21 May 2010 15:55:21 +0200
Message-ID: <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com>
Subject: Re: add devname module aliases to allow module on-demand auto-loading
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 15:39, Nikanth Karthikesan <knikanth@suse.de> wrote:
> On Friday 21 May 2010 18:41:38 Kay Sievers wrote:
>> On Fri, May 21, 2010 at 13:51, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> > On Fri, May 21, 2010 at 13:34, Alasdair G Kergon <agk@redhat.com> wrote:
>> >
>> > There is no harm to make a well-know device node static, it just
>> > solves a lot of problems, and also makes it possible to work off of a
>> > static /dev.
>>
>> To illustrate:
>>
>> On my box without this patch:
>>   dmsetup version
>>   Library version:   1.02.42 (2010-01-14)
>>   /proc/misc: No entry for device-mapper found
>>   Is device-mapper driver missing from kernel?
>>   Failure to communicate with kernel device-mapper driver.
>>
>> And the same box just with this patch, nothing else changed:
>>   dmsetup version
>>   Library version:   1.02.42 (2010-01-14)
>>   Driver version:    4.17.0
>>
>> But its up to you to care if device-mapper just works, or if there is
>> stuff like an init script with modprobe needed to load stuff that
>> might never be needed. :)
>>
>
> If this is needed, the dmsetup itself can do a `modprobe dm` instead of
> printing the message, "Is device-mapper driver missing from kernel?"?

No, it can't. There is a delay until the node appears, unless you use
devtmpfs. This can not be handled reliably by usual non-hotplug-aware
tools.

Also it could be any user of libdevmapper doing this. And running
processes from libraries without the user of the lib knowing all the
problems sub-processes create is not recommended at all.

There is a good reason to let the kernel load the module on-demand,
and not to code all sorts of racy stuff into tools. It's just open(),
nothing else, and it is guaranteed by the kenrel to work, without any
further synchronization.

>> This is surely not about dynamic vs. static, it is about race-free
>> on-demand activation of services and subsystems.
>>
> Loading dm-mod alone is enough for `dmsetup version`. But for other operations
> dm-mod may not be enough, as various other modules like dm-crypt, dm-
> mirror,... would also be required, depending on the dm table, which may or may
> not be installed.

Sure, but that is a detail, that can be solved by kernel-driven
on-demand loading as well.

Kay
