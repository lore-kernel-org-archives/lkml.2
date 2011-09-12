Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1ILOHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab1ILOHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:07:06 -0400
Message-ID: <4E6E1103.2000408@redhat.com>
Date: Mon, 12 Sep 2011 10:02:43 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Sasha Levin <levinsasha928@gmail.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315417137-12093-1-git-send-email-jarod@redhat.com> <1315419179.3576.6.camel@lappy> <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org>
In-Reply-To: <20110907192737.GD20571@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o wrote:
> On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
>> We're looking for a generic solution here that doesn't require
>> re-educating every single piece of userspace. And anything done in
>> userspace is going to be full of possible holes -- there needs to be
>> something in place that actually *enforces* the policy, and
>> centralized accounting/tracking, lest you wind up with multiple
>> processes racing to grab the entropy.
>
> Yeah, but there are userspace programs that depend on urandom not
> blocking... so your proposed change would break them.

I'm already consigned to the fact this isn't going to fly, but I'm still 
curious to know examples of programs that are going to break here, for 
my own education. Its already possible for urandom reads to fail as the 
code is now (-ERESTARTSYS and -EFAULT are possible), so a sane program 
ought to already be handling error cases, though not -EAGAIN, which this 
would add.


-- 
Jarod Wilson
jarod@redhat.com


