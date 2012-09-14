Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2INWCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:02:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33230 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2INWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <1347659777.7172.97.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic> <1347658843.7172.90.camel@twins>
 <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com> <1347659777.7172.97.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Sep 2012 15:01:44 -0700
X-Google-Sender-Auth: 9ctOSDRIxq06X3JMpX-WiVgrYSs
Message-ID: <CA+55aFwKEjsPKYNFkkNfrr9V=vyEO6M9o_48be4y9w6=h-06UQ@mail.gmail.com>
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

On Fri, Sep 14, 2012 at 2:56 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Both things change semantics, not looking at the entire package is new
> too.

Well, the "idle_buddy" thing on its own could be considered to be
purely a caching thing.

Sure, it doesn't take tsk_cpus_allowed() into account while setting up
the cache (since it's not dynamic enough), but *assuming* the common
case is that people let threads be on any of the cores of a package,
it should be possible to make the cache 100% equivalent with no
semantic change. No?

The code doesn't even try to do that kind of "don't change semantics",
though, and makes the idle-buddy thing entirely different.

            Linus
