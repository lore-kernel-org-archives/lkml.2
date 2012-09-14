Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab2INWUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:20:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52478 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab2INWUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:20:53 -0400
MIME-Version: 1.0
In-Reply-To: <1347660634.2341.5.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic> <1347658843.7172.90.camel@twins>
 <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com>
 <1347659777.7172.97.camel@twins> <CA+55aFwKEjsPKYNFkkNfrr9V=vyEO6M9o_48be4y9w6=h-06UQ@mail.gmail.com>
 <1347660634.2341.5.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Sep 2012 15:20:31 -0700
X-Google-Sender-Auth: aklAtDu4oZwUWE5oRVIXdMhUSEw
Message-ID: <CA+55aFw-TZtmqOpchoWo9knB1HPQ60oVDnP=tLyOQ6s6CJGtAA@mail.gmail.com>
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

On Fri, Sep 14, 2012 at 3:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> I'm not seeing how it could be. Only ever looking at 1 other cpu
> (regardless which one) cannot be the same as checking 'all' of them.

Oh, you're right, it has that cpu_idle() in the loop too. So yeah, you
can't make it be even remotely equivalent. You can only make it
equivalent for the "all other cpu's are idle" case.

It doesn't even do *that*, though.

In fact, as far as I can tell, it looks like a cpu could be its own
idle_buddy. That whole logic looks very odd.

I vote we just revert it as "insane". The code really doesn't seem to
make any sense.

               Linus
