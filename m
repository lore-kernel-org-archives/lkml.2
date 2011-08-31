Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1HaQt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:49:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1HaQt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <201108311839.52863.arnd@arndb.de>
References: <4E582577.2060805@zytor.com> <201108311814.54906.arnd@arndb.de>
 <4E5E6075.6060209@zytor.com> <201108311839.52863.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Aug 2011 09:48:35 -0700
Message-ID: <CA+55aFwVJ71=cLsUqMaJ-eGP0doPGBhrse9r++hkbiNYNx5Zjg@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 9:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Well, we could chicken out and just use unsigned int for time_t on new
> 32 bit ABIs, which would buy us time until ~2106 before we need to
> convert everything to 64 bit...

You do realize that there are probably quite a lot of programs that
depend on signed time_t because they really do care about dates before
1970?

"unsigned time_t" is not going to really solve anything. It can be a
crutch for some cases, but seriously, the only solution is to just
admit that a 32-bit time_t just doesn't work.

                Linus
