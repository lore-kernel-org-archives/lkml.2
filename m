Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab2FENQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:16:40 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36122 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103Ab2FENKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:06 -0400
Date: Tue, 5 Jun 2012 15:10:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Cam Macdonell <cam@cs.ualberta.ca>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Rusty Russell <rusty@rustcorp.com.au>, qemu-devel@nongnu.org,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: Re: [RFC PATCH 1/2] ivring: Add a ring-buffer driver on IVShmem
Message-ID: <20120605131031.GF13495@aftab.osrc.amd.com>
References: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp>
 <20120605130117.15479.32680.stgit@ltc189.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605130117.15479.32680.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 10:01:17PM +0900, Yoshihiro YUNOMAE wrote:
> This patch adds a ring-buffer driver for IVShmem device, a virtual RAM device in
> QEMU. This driver can be used as a ring-buffer for kernel logging or tracing of
> a guest OS by recording kernel programing or SystemTap.
> 
> This ring-buffer driver is implemented very simple. First 4kB of shared memory
> region is control structure of a ring-buffer. In this region, some values for
> managing the ring-buffer is stored such as bits and mask of whole memory size,
> writing position, threshold value for notification to a reader on a host OS.
> This region is used by the reader to know writing position. Then, "total
> memory size - 4kB" equals to usable memory region for recording data.
> This ring-buffer driver records any data from start to end of the writable
> memory region.
> 
> When writing size exceeds a threshold value, this driver can notify a reader
> to read data by using writel(). As this later patch, reader does not have any
> function for receiving the notification. This notification feature will be used
> near the future.
> 
> As a writer records data in this ring-buffer, spinlock function is used to
> avoid competing by some writers in multi CPU environment. Not to use spinlock,
> lockless ring-buffer like as ftrace and one ring-buffer one CPU will be
> implemented near the future.

Yet another ring buffer?

We already have an ftrace and perf ring buffer, can't you use one of those?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
