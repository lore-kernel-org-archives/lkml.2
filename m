Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1IHX7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:59:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab1IHX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:59:20 -0400
Date: Thu, 08 Sep 2011 12:13:47 -0400 (EDT)
Message-Id: <20110908.121347.1753630996526838840.davem@davemloft.net>
To: sgrubb@redhat.com
Cc: hch@infradead.org, stephan.mueller@atsec.com, tytso@mit.edu,
        jarod@redhat.com, levinsasha928@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com, nhorman@redhat.com,
        herbert.xu@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: add blocking facility to urandom
From: David Miller <davem@davemloft.net>
In-Reply-To: <201109080748.27750.sgrubb@redhat.com>
References: <4E67E1B0.2040309@atsec.com>
	<20110908084420.GC4032@infradead.org>
	<201109080748.27750.sgrubb@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 08 Sep 2011 09:16:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Grubb <sgrubb@redhat.com>
Date: Thu, 8 Sep 2011 07:48:27 -0400

> On Thursday, September 08, 2011 04:44:20 AM Christoph Hellwig wrote:
>> On Wed, Sep 07, 2011 at 11:27:12PM +0200, Stephan Mueller wrote:
>> > And exactly that is the concern from organizations like BSI. Their
>> > cryptographer's concern is that due to the volume of data that you can
>> > extract from /dev/urandom, you may find cycles or patterns that increase
>> > the probability to guess the next random value compared to brute force
>> > attack. Note, it is all about probabilities.
>> 
>> So don't use /dev/urandom if you don't like the behaviour.  Breaking all
>> existing application because of a certification is simply not an option.
> 
> This patch does not _break_ all existing applications. If a system were under attack, 
> they might pause momentarily, but they do not break. Please, try the patch and use a 
> nice large number like 2000000 and see for yourself. Right now, everyone arguing about 
> this breaking things have not tried it to see if in fact things do break and how they 
> break if they do.

If the application holds a critical resource other threads want when it
blocks on /dev/urandom, then your change breaks things.  I can come up
with more examples if you like.

Please get off this idea that you can just change the blocking behavior
for a file descriptor and nothing of consequence will happen.

When this happens in the networking due to a bug or similar, we know
it does break things.
