Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2A0Sww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:52:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63702 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2A0Swu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:52:50 -0500
MIME-Version: 1.0
In-Reply-To: <1327684589.12089.22.camel@joe2Laptop>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
	<1327674295-3700-2-git-send-email-akinobu.mita@gmail.com>
	<1327684589.12089.22.camel@joe2Laptop>
Date: Fri, 27 Jan 2012 10:52:49 -0800
Message-ID: <CAN8TOE8Hq8f3ipQFxBAHXK5ArSH6wNc8GA5CbYr_xORBa5gAWw@mail.gmail.com>
Subject: Re: [PATCH] mtd/nand: use string library
From: Brian Norris <computersforpeace@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Jiandong Zheng <jdzheng@broadcom.com>,
        akpm@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 9:16 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2012-01-27 at 23:24 +0900, Akinobu Mita wrote:
>> - Use memchr_inv to check if the data contains all 0xFF bytes.
>>   It is faster than looping for each byte.
>
> Stupid question:
>
> Are there any mtd devices modified that are slower
> at 64 bit accesses than repeated 8 bit accesses?

I believe this patch deals with kernel buffers, not any kind of direct
access to the MTD, so the question (which is not stupid IMO) should be
regarding CPU architectures. And my educated guess is that 64-bit
access should not be any slower. I do know that 8-bit access *is*
slower for some relevant architectures.

Brian
