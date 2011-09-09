Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838Ab1IITIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:08:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44797 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759824Ab1IITIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110908.121347.1753630996526838840.davem@davemloft.net>
References: <4E67E1B0.2040309@atsec.com>
	<20110908084420.GC4032@infradead.org>
	<201109080748.27750.sgrubb@redhat.com>
	<20110908.121347.1753630996526838840.davem@davemloft.net>
Date: Fri, 9 Sep 2011 15:08:03 -0400
Message-ID: <CACLa4ptAYEieckVLz+qs9PGfDrw9QjExUx+EMn9tqiCoQ4aqfg@mail.gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
From: Eric Paris <eparis@parisplace.org>
To: David Miller <davem@davemloft.net>
Cc: sgrubb@redhat.com, hch@infradead.org, stephan.mueller@atsec.com,
        tytso@mit.edu, jarod@redhat.com, levinsasha928@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com, nhorman@redhat.com,
        herbert.xu@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 12:13 PM, David Miller <davem@davemloft.net> wrote:
> From: Steve Grubb <sgrubb@redhat.com>

>> This patch does not _break_ all existing applications. If a system were under attack,
>> they might pause momentarily, but they do not break. Please, try the patch and use a
>> nice large number like 2000000 and see for yourself. Right now, everyone arguing about
>> this breaking things have not tried it to see if in fact things do break and how they
>> break if they do.
>
> If the application holds a critical resource other threads want when it
> blocks on /dev/urandom, then your change breaks things.  I can come up
> with more examples if you like.
>
> Please get off this idea that you can just change the blocking behavior
> for a file descriptor and nothing of consequence will happen.

I know it's work porting userspace, but would anyone think that a new
char device to do this would be a good enough idea?  You obviously
already worked out methods to port things which normally use urandom
to use random to discover the problem, so most of the work should be
done.  I suggest /dev/jkrandom (since this is half way between
/dev/random and /dev/urandom and 'u' is the 21st letter it seemed
appropriate to use letters 10 and 11)

Thus userspace can decide what matters.  Always with entropy and
blocks often (random).  From good enough entropy and rarely blocks
(jkrandom).  Possibly from some entropy and never block (urandom).

-Eric
