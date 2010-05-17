Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0EQEQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 00:16:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54805 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0EQEQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 00:16:28 -0400
MIME-Version: 1.0
In-Reply-To: <201005162142.39343.rjw@sisk.pl>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	 <201005162142.39343.rjw@sisk.pl>
Date: Sun, 16 May 2010 21:16:26 -0700
Message-ID: <AANLkTinP68yHYfVCW-urCrRbeSb0Mlz8JsvAs-FKoUPZ@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/16 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday 14 May 2010, Arve Hjønnevåg wrote:
>> This patch series adds a suspend-block api that provides the same
>> functionality as the android wakelock api. This version has some
>> changes from, or requested by, Rafael. The most notable changes are:
>> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
>>   for statically allocated suspend blockers.
>> - suspend_blocker_destroy is now called suspend_blocker_unregister
>> - The user space mandatory _INIT ioctl has been replaced with an
>>   optional _SET_NAME ioctl.
>>
>> I kept the ack and reviewed by tags on two of the patches even though
>> there were a few cosmetic changes.
>
> I have one more comment, sorry for that.
>
> Namely, if /sys/power/policy is set to "opportunistic" and "mem" is written
> into /sys/power/state and there are no suspend blockers present except for
> the main blocker (and the blockers used only for statistics), the system won't
> be able to go out of an infinit suspend-resume loop (or at least it seems
> so from reading the code).
>
> I think we should prevent that from happening somehow.
>

It should get out of that loop as soon as someone blocks suspend. If
someone is constantly aborting suspend without using a suspend blocker
it will be very inefficient, but it should still work.

-- 
Arve Hjønnevåg
