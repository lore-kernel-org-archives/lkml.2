Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0LRUou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 15:44:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46307 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab0LRUos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:44:48 -0500
MIME-Version: 1.0
In-Reply-To: <20101218175408.GA1709@polaris.bitmath.org>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
	<1292683981-6908-2-git-send-email-rydberg@euromail.se>
	<AANLkTimrNrfTXGh675_8zhOg_+9+NKgOmzJq9rafyh+6@mail.gmail.com>
	<20101218175408.GA1709@polaris.bitmath.org>
Date: Sat, 18 Dec 2010 14:44:47 -0600
Message-ID: <AANLkTikNGKgyRrn9EMYA+oXipU2VThCWFe+1sJQn7p8L@mail.gmail.com>
Subject: Re: [PATCH 1/4] Input: synaptics - add multitouch packet support
From: Chris Bagwell <chris@cnpbagwell.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 11:54 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Chris,
>
> Thanks for you comments.
>
>> > While in MT mode and two or three fingers are touching, two sets of
>> > data are sent.  The first is a new format buffer with lower resolution
>> > reporting of stationary finger and the second is standard data format
>> > reporting movement.
>>
>> We should probably update this comment and remove parts that mention
>> stationary and movement.  It appears to be doing finger tracking and
>> first packet is always first touch... except we are getting reports
>> that clickpads/integrated button pads may not be consistently like
>> this.
>
> Yes, good point. Will update.
>
>> This tracking is partly why type B protocol is being used in later patches.
>
> The original thought was that the two points corresponded well to the
> two fingers, only sometimes in the wrong order. The solution then was
> to use the tracking module to order them appropriately. As it turned
> out that the fingers are not followed that well after all, the whole
> idea fell flat, so we resorted to only sending the bounding rectangle,
> which requires no tracking.
>
> All in all, this patchset contains enough information to resolve
> jumping and clickpad issues in user space, at the same time as it
> keeps compatibility with mousedev and older hardware. We know there
> are still issues, but I see no real reason to postpone these changes
> any further.
>

Agree.  I've found no issues in daily usage for a couple of weeks now
and with an unmodified xf86-input-synaptics (newer then 1.3.0 btw).

I can't speak for clickpads since I do not have access to one but I'm
happy to help narrow down any problems.  I really suspect any
remaining issues are on user land side.

The fact that this patch allows BTN_TOOL_DOUBLETAP to finally be sent
will surely help user land filter out cursor jumps much easier as
well.

Chris
