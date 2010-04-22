Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0DVIjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:39:33 -0400
Received: from borg.medozas.de ([188.40.89.202]:42674 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab0DVIjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:39:31 -0400
Date: Thu, 22 Apr 2010 10:39:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [patch] vt: deactive Shift In/Out in unicode mode
In-Reply-To: <4BCE3D88.4010502@zytor.com>
Message-ID: <alpine.LSU.2.01.1004221013430.27555@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr> <20100419153136.3585281f@lxorguk.ukuu.org.uk> <alpine.LSU.2.01.1004191812570.25222@obet.zrqbmnf.qr> <4BCE3D88.4010502@zytor.com>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2010-04-21 01:49, H. Peter Anvin wrote:
>> Alexander mentioned:
>> [quoting the gmane nntp posting which was stripped of To:s and Cc:s]
>>>
>>> Since KOI7 is not used by any glibc locale, your use case is now 
>>> extinct. I think that, unless someone finds out a different use case, 
>>> these SI and SO characters should be deactivated completely (and not 
>>> just in unicode mode).
>> 
>> Alan, do you agree that the entire SI/SO can/should be removed?
>
>VT line drawing characters are generally assumed to be accessible using
>SI/SO (as they are by default.)

Indeed 0x0e 0x71 0x0f generates the same output as U+2501.

I can't say when the last time was that I saw SISO in use, though.
At least UTF-8 programs just print U+2501, so it should
be fine to exclude SISO handling there.
With

	echo -en "\e%@"; setfont r -u /usr/share/kbd/unimaps/cp437.uni;
	LC_CTYPE=C mc

it would also output no SISO and use 0xc4 for U+2501.
