Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab2FEONS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:13:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39028 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2FEONQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:13:16 -0400
X-AuditID: b753bd60-9aaf3ba000000f6c-67-4fce13f9f531
X-AuditID: b753bd60-9aaf3ba000000f6c-67-4fce13f9f531
Message-ID: <4FCE13F1.9020405@hitachi.com>
Date: Tue, 05 Jun 2012 23:13:05 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Reply-To: yoshihiro.yunomae.ez@hitachi.com
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
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
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 1/2] ivring: Add a ring-buffer driver on IVShmem
References: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp> <20120605130117.15479.32680.stgit@ltc189.sdl.hitachi.co.jp> <20120605131031.GF13495@aftab.osrc.amd.com>
In-Reply-To: <20120605131031.GF13495@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/05 22:10), Borislav Petkov wrote:
> On Tue, Jun 05, 2012 at 10:01:17PM +0900, Yoshihiro YUNOMAE wrote:
>> This patch adds a ring-buffer driver for IVShmem device, a virtual RAM device in
>> QEMU. This driver can be used as a ring-buffer for kernel logging or tracing of
>> a guest OS by recording kernel programing or SystemTap.
>>
>> This ring-buffer driver is implemented very simple. First 4kB of shared memory
>> region is control structure of a ring-buffer. In this region, some values for
>> managing the ring-buffer is stored such as bits and mask of whole memory size,
>> writing position, threshold value for notification to a reader on a host OS.
>> This region is used by the reader to know writing position. Then, "total
>> memory size - 4kB" equals to usable memory region for recording data.
>> This ring-buffer driver records any data from start to end of the writable
>> memory region.
>>
>> When writing size exceeds a threshold value, this driver can notify a reader
>> to read data by using writel(). As this later patch, reader does not have any
>> function for receiving the notification. This notification feature will be used
>> near the future.
>>
>> As a writer records data in this ring-buffer, spinlock function is used to
>> avoid competing by some writers in multi CPU environment. Not to use spinlock,
>> lockless ring-buffer like as ftrace and one ring-buffer one CPU will be
>> implemented near the future.
>
> Yet another ring buffer?

Yes, unfortunately...

> We already have an ftrace and perf ring buffer, can't you use one of those?
>
No, because those do not support to allocate buffer
from PCI memory device, nor pass the control structure
over it.

However, indeed, we understand what you would like to say.

This series is just RFC and we'd like to ask who is
interested in the guest tracing and how it should be
implemented.

  - no more ring buffer. enhance perf/ftrace ring buffer to
    enable allocating buffers on shared memory.

Other comments are welcome.

Thank you,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


