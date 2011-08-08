Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1HHUpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:45:30 -0400
Received: from science.horizon.com ([71.41.210.146]:37475 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753364Ab1HHUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:45:26 -0400
Date: 8 Aug 2011 16:45:24 -0400
Message-ID: <20110808204524.12911.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joakim.tjernlund@transmode.se, linux@horizon.com,
        rpearson@systemfabricworks.com
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <002b01cc55ec$db14fb90$913ef2b0$@systemfabricworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Happy to consider this. I have been asking the list for comments about the
> idea of dropping the BITS=2 and BITS=4 algorithms altogether which would
> make the table size just 256. So far no one has claimed that they actually
> care about those algorithms except as 'examples'. The 'Sarwate' algorithm
> (which I added as an 8 bit version) is faster and only adds 2x4KB of table.

Um, I thought the Sarwate agorithm was what was already there as BITS=8.
(The original paper stores the CRC in two 8-bit variables and two
8-bit tables rather than using 16-bit words, but other than that,
it's identical.)

And that requires just 1KB of table per endianness.

Anyway, I thought the complaint about laarge tables was
not so much the memory as the L1 cache pollution.
