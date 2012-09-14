Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab2INVpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:45:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58981 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2INVpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:45:13 -0400
MIME-Version: 1.0
In-Reply-To: <1347658843.7172.90.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic> <1347658843.7172.90.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Sep 2012 14:44:48 -0700
X-Google-Sender-Auth: kaxFyZMnkLEu0D8fLw7UYbHLBw8
Message-ID: <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 2:40 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> The problem the patch is trying to address is not having to scan an
> entire package for idle cores on every wakeup now that packages are
> getting stupid big.

No, it does something *else* too. That whole "left-right" logic to
(according to the commit message) "prevent bouncing" is entirely new,
afaik.

So it is *not* just about avoiding to have to scan the whole package.
It changes actual semantics too. No?

            Linus
