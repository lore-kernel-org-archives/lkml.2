Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab0KOTxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:53:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab0KOTx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:53:29 -0500
Message-ID: <4CE18FA1.4000400@redhat.com>
Date: Mon, 15 Nov 2010 11:53:05 -0800
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Jim Bos <jim876@xs4all.nl>,
        Andi Kleen <andi@firstfloor.org>, James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com> <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz> <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com> <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com> <4CE17C4B.1070305@xs4all.nl> <20101115185848.GI2583@sunsite.ms.mff.cuni.cz> <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
In-Reply-To: <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 11:12 AM, Jakub Jelinek wrote:
> -	  if (simple_cst_equal(TREE_VALUE (op), memory_identifier_string) == 1)
> +	  if (strcmp (TREE_STRING_POINTER (TREE_VALUE (link)), "memory") == 0)

I prefer this solution.  I think memory_identifier_string is over-engineering.
Patch to remove it entirely is pre-approved.


r~
