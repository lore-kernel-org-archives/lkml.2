Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2GXD1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 23:27:34 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57427 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2GXD1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 23:27:32 -0400
X-AuditID: 0ac90646-98cc4ba000003485-7e-500e16210ff2
X-AuditID: 0ac90646-98cc4ba000003485-7e-500e16210ff2
Message-ID: <500E161F.5020207@hitachi.com>
Date: Tue, 24 Jul 2012 12:27:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@amd64.org>, "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
In-Reply-To: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/24 11:36), Yoshihiro YUNOMAE wrote:
> Therefore, we propose a new system "virtio-trace", which uses enhanced
> virtio-serial and existing ring-buffer of ftrace, for collecting guest kernel
> tracing data. In this system, there are 5 main components:
>  (1) Ring-buffer of ftrace in a guest
>      - When trace agent reads ring-buffer, a page is removed from ring-buffer.
>  (2) Trace agent in the guest
>      - Splice the page of ring-buffer to read_pipe using splice() without
>        memory copying. Then, the page is spliced from write_pipe to virtio
>        without memory copying.
>  (3) Virtio-console driver in the guest
>      - Pass the page to virtio-ring
>  (4) Virtio-serial bus in QEMU
>      - Copy the page to kernel pipe
>  (5) Reader in the host
>      - Read guest tracing data via FIFO(named pipe)

So, this is our answer for the argued points in previous thread.
This virtio-serial and ftrace enhancements doesn't introduce new
"ringbuffer" in the kernel, and just use virtio's ringbuffer.
Also, using splice gives us a great advantage in the performance
because of copy-less trace-data transfer.

Actually, one copy should occur in the host (to write it into the pipe),
because removing physical pages of the guest is hard to track and may
involve a TLB flush per page, even if it is done in background.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


