Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0HIGWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:22:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46100 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0HIGWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:22:39 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
Date: Mon, 09 Aug 2010 08:22:34 +0200
In-Reply-To: <1281303490-390-1-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Mon, 9 Aug 2010 06:38:10 +0900")
Message-ID: <87k4o08fv9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> writes:

> remove unnecessary use of RELOC_HIDE(). It only does simple addition of ptr
> and offset, and in this case, offset 0, does nothing. It does NOT do anything
> with linker relocation things. I could find no reason to use it.

It's for the benefit of the compiler, we've had miscompilations
due to undefined overflow for addresses in the past. The optimizer
assumes this won't happen.

Given the x86-64 version normally doesn't overflow, but it's
still safer to have it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
