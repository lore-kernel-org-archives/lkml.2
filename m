Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1AVWWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:22:14 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:59193 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1AVWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:22:13 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Lasse Collin <lasse.collin@tukaani.org>, linux-kernel@vger.kernel.org
Subject: Re: Possible array overrun in lzma_reset()
References: <alpine.LNX.2.00.1101222124360.7746@swampdragon.chaosbits.net>
X-Yow: Vote for ME -- I'm well-tapered, half-cocked, ill-conceived and
 TAX-DEFERRED!
Date: Sat, 22 Jan 2011 23:22:08 +0100
In-Reply-To: <alpine.LNX.2.00.1101222124360.7746@swampdragon.chaosbits.net>
	(Jesper Juhl's message of "Sat, 22 Jan 2011 21:41:05 +0100 (CET)")
Message-ID: <m2bp38r33j.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jj@chaosbits.net> writes:

> 787  		probs = s->lzma.is_match[0];
> At conditional (1): "i < 14134UL" taking true path
> At conditional (2): "i < 14134UL" taking true path
> At conditional (3): "i < 14134UL" taking true path
> 788  		for (i = 0; i < PROBS_TOTAL; ++i)
> Event overrun-local: Overrunning static array of size 32 bytes at byte position 28266 by indexing pointer "probs" with index variable "i".
> Event overrun-local: Note: These bugs are often difficult to see at first glance. Coverity recommends a close inspection of the events leading to this overrun.
> 789  			probs[i] = RC_BIT_MODEL_TOTAL / 2;
> ...
>
> I looked into the report and found that 's->lzma.is_match' is
> 	uint16_t is_match[STATES][POS_STATES_MAX]
> where 'STATES' is '#define STATES 12' and 'POS_STATES_MAX' is '#define POS_STATES_MAX (1 << 4)'.
>
> So I think the checker has a point.

The loop treats the part of the structure from is_match to the end as a
single array of PROBS_TOTAL uint16_t (which it is, in effect).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
