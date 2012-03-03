Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2CCBMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:12:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62411 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2CCBMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:12:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.8.164 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F516DBA.2030809@zytor.com>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
 <4F516811.8060800@zytor.com> <CA+55aFzoOOCOU-N6Zaq8Dd+U0no0a9U5ndU-LA_TrctM5tPP2Q@mail.gmail.com>
 <4F516DBA.2030809@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Mar 2012 17:11:41 -0800
X-Google-Sender-Auth: ysZA_hYRzmZODAG21TtkgBl0UMc
Message-ID: <CA+55aFwoifDB9YPC53KrFm1DZNVEzYL4+dfP96GE3rz8YCVaMg@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 5:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Note that does mean we need a guard page after each and every
> discontiguous RAM range, not just the last one.  Raising that issue
> since we have had serious bugs in that area in the past.

Are you sure? I didn't think we even *mapped* things at that granularity.

We only really need a guard page at the end of an actual end-of-ram
where we no longer have page tables and/or could hit device space.

Which in practice never actually is an issue on PC's - we already
guard against BIOS usage just under the 0xA0000 address, and in
practice there are always ACPI tables at the end of RAM (and on x86-32
we can't use highmem for filenames anyway, so that takes away *those*
cases).

Which is why I think that for testing purposes we don't even need to
care - it's basically a "can't happen" (not to mention that nobody
actually uses PATH_MAX pathames).

For robustness and actual deployment, I do think that yes, we do want
to make it an explicit rule.

                    Linus
