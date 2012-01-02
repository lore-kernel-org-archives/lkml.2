Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2ABHBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:01:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57611 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2ABHB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:01:28 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1325472276.13595.200.camel@deadeye>
References: <1325472276.13595.200.camel@deadeye>
Date: Sun, 1 Jan 2012 23:01:27 -0800
Message-ID: <CAOesGMgXRev24e0bmGD71J04=Aon7bs0YeK7mwX8Na12uR_b6A@mail.gmail.com>
Subject: Re: Circular dependency between <linux/kernel.h> and <asm/bug.h> on ARM
From: Olof Johansson <olof@lixom.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Simon Glass <sjg@chromium.org>, Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 1, 2012 at 6:44 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> Commit 87e040b6456fd3416a1f6831c1eedaef5c0a94ff ("ARM: 7017/1: Use
> generic BUG() handler") makes BUG() use BUILD_BUG_ON().  However,
> BUILD_BUG_ON() is not defined in <linux/bug.h> but in <linux/kernel.h>.
>
> arch/include/asm/bug.h does not include <linux/kernel.h> and *cannot* do
> so because the latter already includes <asm/bug.h>.

Sure it can, but it's not ideal. Since the BUILD_BUG_ON is only used
in bug.h in a #define, it will be resolved below the includes of
either so there should be no ordering issue between the two.

I coincidentally posted a patch earlier to do just that, I didn't see
your email until later.

> Maybe BUILD_BUG_ON() should be moved out to a header of its own, or else
> this particular use should be moved to some other file.  This needs to
> be fixed somehow, as it obviously leads to build failures, e.g.:
>
> https://buildd.debian.org/status/fetch.php?pkg=linux-2.6&arch=armel&ver=3.2~rc7-1~experimental.1&stamp=1325142904

Or perhaps moving BUILD_BUG_ON to include/linux/bug.h?

The quickest fix for now might be to take out the BUILD_BUG_ON(),
especially so close to 3.2-final.


-Olof
