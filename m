Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1HMG0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:26:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63549 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1HMG0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:26:19 -0400
Date: Sat, 13 Aug 2011 10:26:14 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        kernel-hardening@lists.openwall.com,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] x86, mm: start mmap allocation for libs from low
 addresses
Message-ID: <20110813062614.GD3851@albatros>
References: <20110812102954.GA3496@albatros>
 <ccea406f-62be-4344-8036-a1b092937fe9@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccea406f-62be-4344-8036-a1b092937fe9@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 18:19 -0500, H. Peter Anvin wrote:
> This also greatly reduces the address space available for randomization,
> and may get in the way of the default brk.  Is this a net win or lose?

If the executable image is not randomized and is located out of
ASCII-armor, then yes, such allocation doesn't help much.

>  Also, this zero byte is going to be at the last address, which means it might not help.  How about addresses of the form 0xAA00B000 instead?  The last bits are always 000 for a page address, of course...

It leaves only 64kb of library protected, which is useless for most of
programs.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
