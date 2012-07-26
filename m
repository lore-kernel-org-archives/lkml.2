Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab2GZDaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 23:30:11 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38669 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GZDaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 23:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
 <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com> <CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 26 Jul 2012 11:29:48 +0800
X-Google-Sender-Auth: wU2Vl1xQQjkL3gHEqUYPIOqY4OY
Message-ID: <CAK5ve-+11J4HRepAmK-Y0Pq55XhAwa8Ehpw8=KvRdu4Cy90FDQ@mail.gmail.com>
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 2:54 AM, Colin Cross <ccross@android.com> wrote:
> On Tue, Jul 24, 2012 at 11:11 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
>> On Wed, Jul 25, 2012 at 8:32 AM, Colin Cross <ccross@android.com> wrote:
>>> Some triggers create sysfs files when they are enabled.  Send a uevent
>>> "change" notification whenever the trigger is changed to allow userspace
>>> processes such as udev to modify permissions on the new files.
>>>
>>
>> This looks like an workaround only for led trigger, can we fix this in
>> sysfs level?
>
> See the previous discussion here: https://lkml.org/lkml/2012/7/20/458

Thanks, I went through this thread here. Actually it was archived in
my email account, so I missed that during a trip.

Basically, I think this issue is a kind of general issue related to
sysfs, not just only for led trigger system. And adding this uevent
notification to a upper level LED driver is not good to me, if we got
similar issue in other subsystem, we should add similar fix there. Why
not we add this in sysfs when we call device_create_file(). And this
will be benefit for other drivers.

Please point out me why we can't do that in sysfs level. Thanks.
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
