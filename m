Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2DSWra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:47:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51621 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab2DSWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <4F908EA5.4060507@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
	<20120419092255.GA29542@aftab>
	<20120419092630.GD29542@aftab>
	<4F904541.2030200@zytor.com>
	<CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
	<20120419173802.GI3221@aftab.osrc.amd.com>
	<4F90527B.7020005@zytor.com>
	<CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com>
	<9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com>
	<4F9072CA.6030903@gmail.com>
	<4F908EA5.4060507@zytor.com>
Date: Thu, 19 Apr 2012 15:47:28 -0700
Message-ID: <CA+8MBbKz4GNs-mFj5=dCpRe_XLgoKZZz-8GM+FqTMTDBKqJNJw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
From: Tony Luck <tony.luck@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 3:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> One thing that probably would give more of a boost is to use a rbtree or
> similar structure to figure out *which* extable (if any) we should be
> looking at; right now it looks like we linearly walk the modules, and
> don't even look to see if we are inside that module before we do a
> bsearch in that module's extable...

How many entries are in the extable for a typical module?  Perhaps it might
make sense to bundle them all into one sorted combined table? Of course
you would have to have a way to squeeze them back out of the combined
table at module unload time.

This moves the cost to module load/unload time ... which is hopefully rare
compared to table lookup.

-Tony
