Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab1BQVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:16:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60232
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab1BQVQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:16:26 -0500
Date: Thu, 17 Feb 2011 13:17:02 -0800 (PST)
Message-Id: <20110217.131702.112601300.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinA-OP69fqf5jLfedk=dL2vmwdUyzn5E6FHR=Zw@mail.gmail.com>
References: <AANLkTi=bgmRwGXEE_wriYo-5gmyaB43pMUzHf7idiK0k@mail.gmail.com>
	<20110217.130115.71101941.davem@davemloft.net>
	<AANLkTinA-OP69fqf5jLfedk=dL2vmwdUyzn5E6FHR=Zw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 13:11:56 -0800

> EVERY SINGLE OF YOUR ARGUMENTS WORK FOR "pointer" TOO!

It at least will not happen at the current time, because GCC only
plays these games on aggregates.

Also, for exception tables, we've avoided this problem because
we emit the exception tables by hand using inline asm and therefore
explicitly control all aspects of the alignment and size.

The GCC manual even documents the alignment attribute behavior.

Also, please don't shoot the messenger, I didn't make GCC behave this
way but I doubt you'll have any luck undoing this behavior in the
tools which therefore means as pragmatists we have to handle it one
way or another.
