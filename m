Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab0DHMa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:30:57 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:60817 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab0DHMaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:30:55 -0400
Message-ID: <4BBDCC6E.3060702@lumino.de>
Date: Thu, 08 Apr 2010 14:30:38 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de>	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>	<4BBDC7D4.6040301@lumino.de> <20100408.051453.231567150.davem@davemloft.net>
In-Reply-To: <20100408.051453.231567150.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 02:14 PM, David Miller wrote:
> Using the spinlock array idea also doesn't work in userspace
> because any signal handler that tries to do an atomic on the
> same object will deadlock on the spinlock.
>   
Yep. I was beeing afraid of signal issues when thinking about this stuff
(on and off for several months :) ), too.

That is why I finally think that a _completely_ hardware based solution
for each necessary atomic operation is necessary, as well to do Futex
(if not using said "atomic region" workaround for non-SMP), as to do SMP.

I finally think that this might be possible in a decent way with custom
instructions using a - say - 1K Word internal FPGA memory space. But
this might need some changes in the non-arch dependent Kernel and/or
library code as the atomic macros would work on "handles" instead of
pointers (of course these handles would be the old pointers with
"normal" archs) and the words used by the macros would need to be
explicitly allocated and deallocated instead of potentially being just
static variables - even though the "atomic_allocate" macro would just
create a static variable for "normal archs" and return it's address.

-Michael
