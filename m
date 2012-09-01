Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2IATSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:18:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52354 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab2IATSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <50413200.5010104@linaro.org>
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org>
	<20120830230129.GC21501@core.coreip.homeip.net>
	<50413200.5010104@linaro.org>
Date: Sat, 1 Sep 2012 12:18:05 -0700
Message-ID: <CAMbhsRRy+M+5qtptr7_1mwUxCv5mj2HqyQY6pVa5om6-_oK+Mg@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in sysRQ
From: Colin Cross <ccross@google.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 2:52 PM, Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:
> On 12-08-30 05:01 PM, Dmitry Torokhov wrote:
>> Hi Matthieu,
>>
>> On Thu, Aug 30, 2012 at 04:30:54PM -0600, mathieu.poirier@linaro.org wrote:
>>> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
>>>
>>> This patch adds keyreset functionality to the sysrq driver. It
>>> allows certain button/key combinations to be used in order to
>>> trigger device resets.
>>>
>>> The first time the key-combo is detected a work function that syncs
>>> the filesystems is scheduled and the kernel rebooted. If all the keys
>>> are released and then pressed again, it calls panic. Reboot on panic
>>> should be set for this to work.  A platform device that specify a
>>> reset key-combo should be added to the board file to trigger the
>>> feature.
>>
>> Why do we need to involve a platform device and not use, for example, a module
>> parameter, that could be set up from userspace?
>
> The platform device comes from the original design and was included to
> minimise the amount of changes in code that make use of the current
> keyreset driver.
>
> I am definitely willing to explore the possibility of adding module
> parameter to complement the platform data but again, to avoid impacting
> board code I'm in favour of keeping the platform data/device - get back
> to me if you disagree.

I wouldn't worry too much about compatibility with existing board
files, they are unlikely to move to a new driver anyways, and if they
do, changing the way they are configured is not a big deal.  That
said, I generally don't like module parameters because it ends up
cluttering the kernel command line with configuration for every
device.  Setting them through sysfs is too late, if a device with a
non-removable battery hangs during boot you would like to be able to
reset it with this driver.
