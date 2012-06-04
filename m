Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010Ab2FDVaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:30:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48676 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761002Ab2FDVaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:30:21 -0400
Message-ID: <4FCD28C7.3050402@zytor.com>
Date: Mon, 04 Jun 2012 14:29:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Kevin Hilman <khilman@ti.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/4 V2] introduce: livedump
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 02:12 AM, YOSHIDA Masanori wrote:
> 
> Such a mechanism is useful especially in the case where very important
> systems are consolidated onto a single machine via virtualization.
> Assuming a KVM host runs multiple important VMs on it and one of them
> fails, the other VMs have to keep running. However, at the same time, an
> administrator may want to obtain memory dump of not only the failed guest
> but also the host because possibly the cause of failture is not in the
> guest but in the host or the hardware under it.
> 
> Live Dump is based on Copy-on-write technique. Basically processing is
> performed in the following order.
> (1) Suspends processing of all CPUs.
> (2) Makes pages (which you want to dump) read-only.
> (3) Resumes all CPUs
> (4) On page fault, dumps a page including a fault address.
> (5) Finally, dumps the rest of pages that are not updated.
> 
> Currently, Live Dump is just a simple prototype and it has many
> limitations. I list the important ones below.
> (1) It write-protects only kernel's straight mapping areas. Therefore
>     memory updates from vmap areas and user space don't cause page fault.
>     Pages corresponding to these areas are not consistently dumped.
> (2) It supports only x86-64 architecture.
> (3) It can only handle 4K pages. As we know, most pages in kernel space are
>     mapped via 2M or 1G large page mapping. Therefore, the current
>     implementation of Live Dump splits all large pages into 4K pages before
>     setting up write protection.
> (4) It allocates about 50% of physical RAM to store dumped pages. Currently
>     Live Dump saves all dumped data on memory once, and after that a user
>     becomes able to use the dumped data. Live Dump itself has no feature to
>     save dumped data onto a disk or any other storage device.
> 

I am very concerned about the impact of this patch versus its value...
losing half the RAM means the value is extremely limited and the other
limitations above indicates that the cost is very very high.

At the same time, the guest can be dumped without any special tricks.

	-hpa

