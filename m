Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0LARdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:33:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57169 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab0LARdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:33:49 -0500
MIME-Version: 1.0
In-Reply-To: <20101201161927.GC9337@hack>
References: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com>
	<AANLkTim=srU8kv-DwL4jgwRS-yH8WN34PgCqsijZvYeV@mail.gmail.com>
	<20101201161927.GC9337@hack>
Date: Wed, 1 Dec 2010 17:33:48 +0000
X-Google-Sender-Auth: 7A0evGTTA9WXWdcVfzpZJmJUgv4
Message-ID: <AANLkTikFt=dyEdsKp+VtU76pKyoLzdug1ZDPPD-3h=K-@mail.gmail.com>
Subject: Re: Problems using EXPORT_SYMBOL with lib/flex_array
From: Alex Bennee <kernel-hacker@bennee.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 December 2010 16:19, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Dec 01, 2010 at 01:20:30PM +0000, Alex Bennee wrote:
>>On 1 December 2010 12:05, Alex Bennee <kernel-hacker@bennee.com>
wrote:
<snip>
>>Tweaking the lib/Makefile so obj-y included flex_array.o did
>>the trick.
>>
>>I'm unsure if this behaviour is what is wanted?
>
> Yes, but not sure about flex_array.o.
> Which functions in flex_array.c do you need in your module anyway?

I want to use it to store a sparse array of ATM cell re-assembly
buffers for my ATM over Ethernet driver. Using the per-vcc user_back
structure causes problems when stacked with things like br2684.

So I'm currently using flex_array_alloc/free/clear/put although I
exported them all. I would have thought using library functions was
preferable to rolling your own?

I'm open to other suggestions though.

-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
