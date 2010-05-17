Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0EQUvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:51:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0EQUvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:51:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YRbCh2TAp1hxF1CRJEd3fJRZOZARB9vnTIl62q/kg450xccom8qvElNGtZRR2qscj
	B6NktyPq4nDxdL2tnR1wQ==
MIME-Version: 1.0
In-Reply-To: <201005172240.35742.rjw@sisk.pl>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	 <201005162142.39343.rjw@sisk.pl>
	 <AANLkTinP68yHYfVCW-urCrRbeSb0Mlz8JsvAs-FKoUPZ@mail.gmail.com>
	 <201005172240.35742.rjw@sisk.pl>
Date: Mon, 17 May 2010 13:51:16 -0700
Message-ID: <AANLkTim2b8cKnzPgN7m5zImb0hVDfqVjRidKNVoYi1yO@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
From: Brian Swetland <swetland@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 1:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 17 May 2010, Arve Hjønnevåg wrote:
>>
>> It should get out of that loop as soon as someone blocks suspend. If
>> someone is constantly aborting suspend without using a suspend blocker
>> it will be very inefficient, but it should still work.
>
> Well, the scenario I have in mind is the following.  Someone wants to check
> the feature and simply writes "opportunistic" to /sys/power/policy and "mem" to
> /sys/power/state without any drivers or apps that use suspend blockers.
>
> How in that case is the system supposed to break out of the suspend-resume loop
> resulting from this?  I don't see right now, because the main blocker is
> inactive, there are no other blockers that can be activated and it is next to
> impossible to write to /sys/power/state again.

I guess we could set a flag when a suspend blocker is registered and
refuse to enter opportunistic mode if no blockers have ever been
registered.

It does seem like extra effort to go through to handle a "don't do
that" type scenario (entering into opportunistic suspend without
anything that will prevent it).

Brian
