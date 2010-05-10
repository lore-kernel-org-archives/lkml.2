Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0EJJsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:48:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:60877 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0EJJsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:48:33 -0400
Subject: [PATCH/WIP] lmb cleanups and additions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       davem@davemloft.net, lethal@linux-sh.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 19:48:13 +1000
Message-ID: <1273484893.23699.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resent that header email, git send-email is having hickups here)

This is my current WIP series. It's compile tested on ppc and sparc64 and
quickly boot tested on ppc64. The "advanced" features such as the new
array resize are completely untested in this version.

My aim is still to replace the bottom part of Yinghai's patch series
rather than build on top of it, and from there, add whatever he needs
to successfully port x86 over and turn NO_BOOTMEM into something half
decent without adding a ton of unneeded crap to the core lmb.

This is not finished tho. Here's a peek at my TODO list:

 - Move to mm/lmb.c

 - Various random return types with non-useful return codes (lmb_add, lmb_remove, ...)
   needs cleaning & documenting

 - Add docbook for all API functions

 - lmb_add or lmb_reserve of overlapping regions are going to wreck things in very
   interesting ways. We could easily error out but that's sub-optimal, instead we
   should break them up to only add/reserve the bits that aren't yet

 - Add some pr_debug in various places in there

 - Improve the NUMA interaction

In the meantime, comments are welcome :-)

Cheers,
Ben.


