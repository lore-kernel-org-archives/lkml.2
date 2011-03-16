Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1CPSKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:10:30 -0400
Received: from science.horizon.com ([71.41.210.146]:18834 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751200Ab1CPSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:10:25 -0400
Date: 16 Mar 2011 14:10:23 -0400
Message-ID: <20110316181023.2090.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hughd@google.com, linux@horizon.com
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com, penberg@cs.helsinki.fi
In-Reply-To: <alpine.LSU.2.00.1103161011370.13407@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm intrigued: please educate me.  On what architectures does cache-
> aligning a 48-byte buffer (previously offset by 4 bytes) speed up
> copying from it, and why?  Does the copying involve 8-byte or 16-byte
> instructions that benefit from that alignment, rather than cacheline
> alignment?

I had two thoughts in my head when I wrote that:
1) A smart compiler could note the alignment and issue wider copy
   instructions.  (Especially on alignment-required architectures.)
2) The cacheline fetch would get more data faster.  The data would
   be transferred in the first 6 beats of the load from RAM (assuming a
   64-bit data bus) rather than waiting for 7, so you'd finish the copy
   1 ns sooner or so.  Similar 1-cycle win on a 128-bit Ln->L(n-1) cache
   transfer.

As I said, "infinitesimal".  The main reason that I bothered to
generate a patch was that it appealed to my sense of neatness to
keep the 3x16-byte buffer 16-byte aligned.
