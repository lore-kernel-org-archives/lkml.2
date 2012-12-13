Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab2LMDJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:09:56 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33041 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2LMDJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:09:55 -0500
MIME-Version: 1.0
In-Reply-To: <50C94561.3070800@gmail.com>
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94561.3070800@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 19:09:33 -0800
X-Google-Sender-Auth: KU9q-7_P3CvGrFNQVPPs8kVOOIE
Message-ID: <CA+55aFwD3fFn7iYSnLw7iFk88xPYaVXMQVDyQans77PydgaeGg@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 7:02 PM, David Ahern <dsahern@gmail.com> wrote:
>
> Can you add -v and see if it spits out more info?

No more info.

Sure, it does the usual "do  you have an APIC" message (it does that
without "-v" too), which isn't useful:

  Error: sys_perf_event_open() syscall returned with 95 (Operation not
supported) for event cycles:pp. /bin/dmesg may provide additional
information.

  No hardware sampling interrupt available. No APIC? If so then you
can boot the kernel with the "lapic" boot parameter to force-enable
it.

And yes, I have a local apic. Every single modern CPU does.

The error message is garbage and actively misleading. Lack of an APIC
is just about the *least* likely possible reason for the EOPNOTSUPP
error return.

              Linus
