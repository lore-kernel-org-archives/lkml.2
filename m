Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0C1WzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 18:55:16 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:33537 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0C1WzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 18:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <20100326030208.GA5815@linux-sh.org>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
	 <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk>
	 <20100323211843.GC19572@n2100.arm.linux.org.uk>
	 <7d08b87d1003241348g347f092k1142318490e0bdcc@mail.gmail.com>
	 <20100326024759.GN19308@shareable.org>
	 <20100326030208.GA5815@linux-sh.org>
Date: Mon, 29 Mar 2010 00:55:11 +0200
Message-ID: <7d08b87d1003281555h1eb255f8ic3bcdec08008d5b2@mail.gmail.com>
Subject: Re: [C/R ARM][PATCH 3/3] c/r: ARM implementation of 
	checkpoint/restart
From: Christoffer Dall <christofferdall@christofferdall.dk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jamie Lokier <jamie@shareable.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       containers <containers@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 5:02 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, Mar 26, 2010 at 02:47:59AM +0000, Jamie Lokier wrote:
>>
>> It's possible in principle to run many non-MMU binaries on MMU
>> kernels, but I've never heard of anyone doing it.
>>
> FDPIC supports running the same binaries with or without MMU depending on
> your ABI, it's not really that uncommon, even if it's mostly just used
> for prototyping.
>
I would imagine that the chance that a restart will fail anyway when
restoring an MMU process on a non-MMU kernel. However, as you suggest,
the other way around should be possible. Thanks for clearing that up.

Specifically, do you know the meaning of the end_brk field on the
mm_context_t struct and if I need to checkpoint it on restart for
non-MMU systems (and potentially do something more clever during
restart on an MMU kernel?)
