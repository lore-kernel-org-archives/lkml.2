Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0EQXcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:32:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40155 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab0EQXct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <201005172344.46222.rjw@sisk.pl>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	 <201005172240.35742.rjw@sisk.pl>
	 <AANLkTim2b8cKnzPgN7m5zImb0hVDfqVjRidKNVoYi1yO@mail.gmail.com>
	 <201005172344.46222.rjw@sisk.pl>
Date: Mon, 17 May 2010 16:32:48 -0700
Message-ID: <AANLkTikENyp0UOKP2NzwjKye1EiZitdE0o4k1Z4ygCsT@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Brian Swetland <swetland@google.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 2:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 17 May 2010, Brian Swetland wrote:
>> On Mon, May 17, 2010 at 1:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Monday 17 May 2010, Arve Hjønnevåg wrote:
>> >>
>> >> It should get out of that loop as soon as someone blocks suspend. If
>> >> someone is constantly aborting suspend without using a suspend blocker
>> >> it will be very inefficient, but it should still work.
>> >
>> > Well, the scenario I have in mind is the following.  Someone wants to check
>> > the feature and simply writes "opportunistic" to /sys/power/policy and "mem" to
>> > /sys/power/state without any drivers or apps that use suspend blockers.
>> >
>> > How in that case is the system supposed to break out of the suspend-resume loop
>> > resulting from this?  I don't see right now, because the main blocker is
>> > inactive, there are no other blockers that can be activated and it is next to
>> > impossible to write to /sys/power/state again.
>>
>> I guess we could set a flag when a suspend blocker is registered and
>> refuse to enter opportunistic mode if no blockers have ever been
>> registered.
>>
>> It does seem like extra effort to go through to handle a "don't do
>> that" type scenario (entering into opportunistic suspend without
>> anything that will prevent it).
>
> I agree, but I think it's necessary.  We shouldn't add interfaces that hurt
> users if not used with care.
>

I'm not sure this can be "fixed". The user asked that the system to
suspend whenever possible, which is what it is doing. I don't think
disabling opportunistic suspend if no suspend blockers have been
registered will work. As soon as we register a suspend blocker we are
back in the same situation.

-- 
Arve Hjønnevåg
