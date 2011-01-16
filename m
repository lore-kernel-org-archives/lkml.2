Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1APH0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 02:26:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35201 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1APH0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 02:26:41 -0500
MIME-Version: 1.0
In-Reply-To: <201101110854.15653.jeremy.kerr@canonical.com>
References: <1294199462.347935.472473715866.0.gpush@pororo>
 <20110110104122.GI12078@pengutronix.de> <20110110110028.GB12552@n2100.arm.linux.org.uk>
 <201101110854.15653.jeremy.kerr@canonical.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 16 Jan 2011 00:26:20 -0700
X-Google-Sender-Auth: YetNNM_JQ9hoLja_bikM5ISgzu0
Message-ID: <AANLkTikjnz6RBCpOZM2imzX3d1ANUkaOZ2Qg9nqhpfpt@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add a common struct clk
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 5:54 PM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
> Hi Russell,
>
>> Unless the locking problems can be resolved, the patches aren't ready.
>>
>> From what I've seen there's still quite a problem with what kind of
>> lock to use in the clock - mutex or spinlock.
>
> Yes, the clock driver may either use a spinlock or mutex.
>
> However, this exactly the same as the current clock code, my patches do not
> alter what we currently have.
>
> I do agree that we should define some specific semantics for the clock API
> with regards to sleeping, and I'll start a new thread about that. But we
> should definitely separate that issue from the problem of having multiple
> definitions for struct clk, which is what these patches address.

Given that each current struct clk implementation makes it's own
decisions about how to handle locking, would it not make sense to omit
locking entirely?  At least as a first step?  Let the clock ops
implement their own locking.  Make enable count management their
responsibility too.  That's all that the lock protects anyway.  The
clk_* apis can fall directly through to the ops hooks with no
manipulation or locking.  The way v3 of the patch worked.

Just having a common struct clk definition (without the locking) is
valuable on its own to get closer to supporting multiple platforms
with a single kernel on ARM.  It certainly shouldn't be worse that the
current state.  Locking consolidation can be implemented in follow-on
patches.

g.
