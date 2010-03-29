Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0C2DhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 23:37:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58999 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab0C2DhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 23:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UYxnfMx56+PUtSxNQ4XVzisYiKla3mMSEVlIhjRrxFw894dYdDUZPlZGGm7lRXmxlF
         r3b16dHNNG6gNB7n3PtGfbLCEBZgNtFnhnqnvHteIJvaMPiKHLDFTZrAqmlUtjRO/0J3
         lUCIKV/Dbl4kqDFy7iAZKmUIsGDH6Irz0TNuA=
MIME-Version: 1.0
Date: Sun, 28 Mar 2010 23:37:21 -0400
Message-ID: <b4198de61003282037p502e9fbfi62123088b9d73923@mail.gmail.com>
Subject: Discrepancy between comments for sched_find_first_bit
From: Matt Turner <mattst88@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/asm-generic/bitops/sched.h says
/*
 * Every architecture must define this function. It's the fastest
 * way of searching a 100-bit bitmap.  It's guaranteed that at least
 * one of the 100 bits is cleared.
 */

arch/alpha/include/asm/bitops.h says
/*
 * Every architecture must define this function. It's the fastest
 * way of searching a 140-bit bitmap where the first 100 bits are
 * unlikely to be set. It's guaranteed that at least one of the 140
 * bits is set.
 */

Is the guarantee that one of the first 100-bits set (and that the last
40 are useless?), or 140-bits? If it's just the first 100 bits we care
about, then the alpha version needs to be fixed.

I'm just checking this out, because gcc produces horrendous code for
sched_find_first_bit on alpha. I rewrote it in assembly and it's
better than 4 times faster.

Also, is it even worth optimizing that function? It looks like it's
only used in kernel/sched_rt.c.

Thanks,
Matt
