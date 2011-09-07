Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1IGTtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:49:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40697 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab1IGTth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:49:37 -0400
Date: Wed, 07 Sep 2011 15:49:24 -0400 (EDT)
Message-Id: <20110907.154924.1213552068898117151.davem@davemloft.net>
To: tytso@mit.edu
Cc: jarod@redhat.com, levinsasha928@gmail.com, linux-crypto@vger.kernel.org,
        mpm@selenic.com, nhorman@redhat.com, herbert.xu@redhat.com,
        sgrubb@redhat.com, stephan.mueller@atsec.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: add blocking facility to urandom
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110907192737.GD20571@thunk.org>
References: <1315419179.3576.6.camel@lappy>
	<4E67B75B.8010500@redhat.com>
	<20110907192737.GD20571@thunk.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Sep 2011 12:49:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ted Ts'o" <tytso@mit.edu>
Date: Wed, 7 Sep 2011 15:27:37 -0400

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

Agreed, and this is a really poor approach to solving the problem.

If you change semantics, you have to create a new facility and then
convert the userland pieces over to it.

Yes, this is harder and requires more work, but it is necessary as
it is the only way to ensure that we won't break something.
