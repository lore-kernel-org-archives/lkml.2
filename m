Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1FHUUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:20:18 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:52401 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1FHUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:20:14 -0400
Message-ID: <4DEFD979.50405@tilera.com>
Date: Wed, 8 Jun 2011 16:20:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
References: <1306772228-1603-1-git-send-email-minipli@googlemail.com>	<20110606161254.5f02d855.akpm@linux-foundation.org>	<BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>	<20110608104727.GT11521@ZenIV.linux.org.uk> <BANLkTi=qBx0Mk=b2wsA3RZVKk0RUckeN6g@mail.gmail.com>
In-Reply-To: <BANLkTi=qBx0Mk=b2wsA3RZVKk0RUckeN6g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/2011 8:14 AM, Mathias Krause wrote:
> On Wed, Jun 8, 2011 at 12:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Tue, Jun 07, 2011 at 07:00:24PM -0700, Linus Torvalds wrote:
>>> That said, that commit (it's commit ID 4095b99c09e3d in tglx's tree)
>>> predates the "real" BK history too: it's part of the (limited) 2.4.x
>>> history that was imported from the release patches into BK at the
>>> beginning of the use of BK. So at that point we didn't do indivual
>>> commits, it's just the import of the v2.4.3.7 -> v2.4.3.8 patch.
>>>
>>> But yeah, it's old and crufty. And I agree that usually the correct
>>> fix is to remove the set_fs() calls entirely.
>> I think these days its job is done by start_thread(), which is where we
>> switch to USER_DS; it's called by ->load_binary() when it decides it's past
>> the point of no return.  However, it would be a good idea to verify that
>> all architectures do it there properly and we are not exposing a hole by
>> removal of this set_fs()...
> I've checked all implementations of start_thread() and found some candidates:
>
> SPARC, TILE and Xtensa don't call set_fs(USER_DS), albeit have
> different definitions for USER_DS and KERNEL_DS. So those might need
> fixing. I'm not familiar with those architectures, so someone else has
> to answer this.

TILE relies on the set_fs() in search_binary_handler(), but adding
set_fs(USER_DS) in in start_thread() should be a valid change if the
set_fs() is removed from search_binary_handler().  I'm happy to ack the
obvious change for tile, or I can put the change to tile's start_thread()
in my tree for inclusion in 3.1, either way.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


