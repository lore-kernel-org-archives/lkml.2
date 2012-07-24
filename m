Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2GXKCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:02:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45352 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2GXKCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
Date: Tue, 24 Jul 2012 11:02:04 +0100
Message-ID: <CAJSP0QW_2JJ0nf=NW0y30VSid2HSxaqb=mRGV8CTtAKj0ujDWw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, qemu-devel@nongnu.org,
        Borislav Petkov <bp@amd64.org>,
        virtualization@lists.linux-foundation.org,
        "Franch Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 3:36 AM, Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com> wrote:
> The performance of each method is compared as follows:
>  [1] Native
>      - only recording trace data to ring-buffer on a guest
>  [2] Virtio-trace
>      - running a trace agent on a guest
>      - a reader on a host opens FIFO using cat command
>  [3] IVRing
>      - A SystemTap script in a guest records trace data to IVRing.
>        -- probe points are same as ftrace.
>  [4] Virtio-serial(normal)
>      - A reader(using cat) on a guest output trace data to a host using
>        standard output via virtio-serial.

The first time I read this I thought you are adding a new virtio-trace
device.  But it looks like this series really add splice support to
virtio-console and that yields a big performance improvement when
sending trace_pipe_raw.

Guest ftrace is useful and I like this.  Have you thought about
controlling ftrace from the host?  Perhaps a command could be added to
the QEMU guest agent which basically invokes trace-cmd/perf.

Are you using text formatted ftrace?

Stefan
