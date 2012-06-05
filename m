Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2FEXWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:22:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56219 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2FEXWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:22:22 -0400
Date: Wed, 6 Jun 2012 08:22:10 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Borislav Petkov <bp@amd64.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>, qemu-devel@nongnu.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, systemtap@sourceware.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Cam Macdonell <cam@cs.ualberta.ca>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: Re: [Qemu-devel] [RFC PATCH 1/2] ivring: Add a ring-buffer driver on
 IVShmem
Message-ID: <20120605232210.GA8858@kroah.com>
References: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp>
 <20120605130117.15479.32680.stgit@ltc189.sdl.hitachi.co.jp>
 <20120605131031.GF13495@aftab.osrc.amd.com>
 <4FCE902A.3060603@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCE902A.3060603@codemonkey.ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 07:03:06AM +0800, Anthony Liguori wrote:
> On 06/05/2012 09:10 PM, Borislav Petkov wrote:
> >On Tue, Jun 05, 2012 at 10:01:17PM +0900, Yoshihiro YUNOMAE wrote:
> >>This patch adds a ring-buffer driver for IVShmem device, a virtual RAM device in
> >>QEMU. This driver can be used as a ring-buffer for kernel logging or tracing of
> >>a guest OS by recording kernel programing or SystemTap.
> >>
> >>This ring-buffer driver is implemented very simple. First 4kB of shared memory
> >>region is control structure of a ring-buffer. In this region, some values for
> >>managing the ring-buffer is stored such as bits and mask of whole memory size,
> >>writing position, threshold value for notification to a reader on a host OS.
> >>This region is used by the reader to know writing position. Then, "total
> >>memory size - 4kB" equals to usable memory region for recording data.
> >>This ring-buffer driver records any data from start to end of the writable
> >>memory region.
> >>
> >>When writing size exceeds a threshold value, this driver can notify a reader
> >>to read data by using writel(). As this later patch, reader does not have any
> >>function for receiving the notification. This notification feature will be used
> >>near the future.
> >>
> >>As a writer records data in this ring-buffer, spinlock function is used to
> >>avoid competing by some writers in multi CPU environment. Not to use spinlock,
> >>lockless ring-buffer like as ftrace and one ring-buffer one CPU will be
> >>implemented near the future.
> >
> >Yet another ring buffer?
> >
> >We already have an ftrace and perf ring buffer, can't you use one of those?
> 
> Not to mention virtio :-)
> 
> Why not just make a virtio device for this kind of thing?

Yeah, that's exactly what I was thinking, why reinvent things again?

greg k-h
