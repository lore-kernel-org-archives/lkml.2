Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1GGNMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:12:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40277 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab1GGNMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:12:06 -0400
Date: Thu, 07 Jul 2011 06:11:59 -0700 (PDT)
Message-Id: <20110707.061159.1960862007945782564.davem@davemloft.net>
To: loke.chetan@gmail.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, joe@perches.com,
        bhutchings@solarflare.com, shemminger@vyatta.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next af-packet 1/2] Enhance af-packet to provide
 (near zero)lossless packet capture functionality.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAAsGZS4Y=-GSmP+2iYtd+V3RcE2+PpaStBzW7R7TDip7U-rdvA@mail.gmail.com>
References: <CAAsGZS67G8H5NLBxQTY88+T1cRQ3aiwBXK5qa8SJ_TbQ7xqvhw@mail.gmail.com>
	<20110707.001301.1054777374178479078.davem@davemloft.net>
	<CAAsGZS4Y=-GSmP+2iYtd+V3RcE2+PpaStBzW7R7TDip7U-rdvA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 07 Jul 2011 06:12:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chetan loke <loke.chetan@gmail.com>
Date: Thu, 7 Jul 2011 09:04:58 -0400

> On Thu, Jul 7, 2011 at 3:13 AM, David Miller <davem@davemloft.net> wrote:
> 
>> Get rid of __packed__, it's going to kill performance on RISC
>> platforms.  If you use __packed__, regardless of the actual alignment,
> 
> The performance boost has been achieved by amortizing the cost of
> static spin-wait/poll and not by shrinking the data-set.

Chetan, if you're implementing something for performance reasons,
getting rid of packed is non-negotiable.

We pass data structures between userspace and the kernel all the
time, and without __packed__.  We have mechanisms to ensure the
size of the individual data types, and we have mechanisms to make
sure 64-bit datums get aligned even on x86 (see "aligned_u64" and
friends")

Again, I can't seriously consider your patch if you keep the packed
attribute crap in there.
