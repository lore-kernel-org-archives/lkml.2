Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2DSR1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:27:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34292 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2DSR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:27:31 -0400
MIME-Version: 1.0
In-Reply-To: <4F904541.2030200@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab> <4F904541.2030200@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 10:27:09 -0700
X-Google-Sender-Auth: VjJdABlIqDDB-gXj_z8xD4tnpyI
Message-ID: <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:02 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> ... and I would be *even happier* with an O(1) hash (which pretty much
> *have* to be constructed at compile time.)

Taking relocations into account might be interesting for hashing. I
guess you could hash the relative offsets, though.

But yeah, a hash might be the way to go, and once you generate the
tables at compile-time, why not go all the way? It doesn't need to be
some complex perfect hash, it should be fairly straightforward to just
size the hash right and use some simple linear probing model for
collissions or whatever.

                  Linus
