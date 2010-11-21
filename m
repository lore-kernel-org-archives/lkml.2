Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab0KUOPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:15:30 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:37158 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0KUOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:15:29 -0500
Date: Sun, 21 Nov 2010 09:15:22 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Stefani Seibold <stefani@seibold.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: cleaning up some inline kfifo docs
Message-ID: <alpine.DEB.2.00.1011210909430.10696@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  (primarily to stefani but others are free to jump in.)

a few things that can be tweaked in <linux/kfifo.h>, but i'd rather
leave that to the maintainer.

  besides some pedantic typoes in kfifo.h, there is a mismatch in the
rounding info.  kfifo.h reads:

  "* The numer of elements will be rounded-up to a power of 2."

while kernel/kfifo.c makes it clear that it goes the other way:

int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
                size_t esize, gfp_t gfp_mask)
{
        /*
         * round down to the next power of 2, since our 'let the indices
         * wrap' technique works only in this case.
         */
        if (!is_power_of_2(size))
                size = rounddown_pow_of_two(size);


  so the kfifo.h claim should be fixed.  also, in a number of places,
kfifo.h claims that the size passed to the kfifo creation routine
*must* be a power of two when, clearly, it doesn't have to be; it will
simply be *rounded* to such a power as needed.

  take it away, stefani ...

rday


-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
