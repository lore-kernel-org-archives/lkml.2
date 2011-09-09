Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab1IIOjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:39:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758401Ab1IIOjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:39:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110909081407.GA29251@liondog.tnic>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
 <20110812195220.GA29051@elte.hu> <20110814095910.GA18809@liondog.tnic>
 <6296.1313462075@turing-police.cc.vt.edu> <20110816121604.GA29251@aftab>
 <4E5FA18A.7010205@gmail.com> <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com>
 <20110908083551.GA5646@liondog.tnic> <4E689FC5.8010005@gmail.com> <20110909081407.GA29251@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Sep 2011 07:39:18 -0700
Message-ID: <CA+55aFy5QOwQXqHkOkoMU_Lg6DrhrwVpMx4R0kFTnKqmACGy6w@mail.gmail.com>
Subject: Re: x86 memcpy performance
To: Borislav Petkov <bp@alien8.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 1:14 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> which looks like pretty nice numbers to me. I can't say whether there
> ever is 16K buffer we copy in the kernel but if there were...

Kernel memcpy's are basically almost always smaller than a page size,
because that tends to be the fundamental allocation size.

Yes, there are exceptions that copy into big vmalloc'ed buffers, but
they don't tend to matter. Things like module loading etc.

                     Linus
