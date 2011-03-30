Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1C3QvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:51:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864Ab1C3QvG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103301845020.22418@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6>
 <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com>
 <alpine.LFD.2.00.1103301827530.22418@localhost6.localdomain6> <alpine.LFD.2.00.1103301845020.22418@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 09:50:43 -0700
Message-ID: <AANLkTikeMFpxVW2bU+CXh=VVPBf2Tm4ccMFBUELSeVy4@mail.gmail.com>
Subject: Re: [GIT pull] irq fixes for .39.rc
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 9:46 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 30 Mar 2011, Thomas Gleixner wrote:
>> On Wed, 30 Mar 2011, Linus Torvalds wrote:
>> >
>> > which just makes me go "Somebody is really really confused".
>> >
>> > The whole thing may mean that both handler_data and chip_data contains
>> > the right thing, but it still makes me go "WTF?".
>> >
>> > Which way should I resolve it?
>>
>> get_irq_desc_data() maps to irq_desc_get_handler_data() so Richards
>> resolution is correct even if the other might work as well.
>
> Older code which was not using any accessors has:
>
>      desc->handler_data
>
> But yeah, the init stuff is confusing as hell.

So I took the handler_data version, but I do think the chip_data one
seems to make more conceptual sense. It would be good if somebody who
can actually test that code and knows all the details of the
particular irq controller could just take a look, and decide on using
one or the other, and not both.

I pushed out my resolution (but the mirroring has been slow lately, so
it might take a while to show up on git.kernel.org - it's there on
master now, though)

                  Linus
