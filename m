Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2IMKKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:10:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45841 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2IMKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:10:13 -0400
Message-ID: <5051B101.4030806@canonical.com>
Date: Thu, 13 Sep 2012 12:10:09 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockdep: Check if nested lock is actually held
References: <5051A9E7.5040501@canonical.com> <1347530393.15764.115.camel@twins>
In-Reply-To: <1347530393.15764.115.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 13-09-12 11:59, Peter Zijlstra schreef:
> On Thu, 2012-09-13 at 11:39 +0200, Maarten Lankhorst wrote:
>> It is considered good form to lock the lock you claim to be nested in.
> Uhm yeah.. cute. You actually found a site where this triggered?
>
Not in mainline, I was working on some lockdep annotations for my work on
moving ttm reservations to base kernel, and I wrote a whole bunch of tests
to stress interaction between reservations and locks, one of the tests I
was doing was taking a spinlock without the nested object:

static void reservation_test_fence_nest_unreserved(void)
{
	struct reservation_object o;

	reservation_object_init(&o);

	spin_lock_nest_lock(&o.fence_lock, &o);
	spin_unlock(&o.fence_lock);
}

I would have expected it to fail, and the patch fixed it. As a nice side effect
it also complained about another hack I was doing elsewhere with reservations to
tests for deadlocks, and it forced me to fix it in a slightly less hacky way.

~Maarten

