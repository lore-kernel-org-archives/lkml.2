Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2FEXDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:03:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2FEXDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:03:17 -0400
Message-ID: <4FCE902A.3060603@codemonkey.ws>
Date: Wed, 06 Jun 2012 07:03:06 +0800
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>, qemu-devel@nongnu.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, systemtap@sourceware.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Cam Macdonell <cam@cs.ualberta.ca>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: Re: [Qemu-devel] [RFC PATCH 1/2] ivring: Add a ring-buffer driver
 on IVShmem
References: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp> <20120605130117.15479.32680.stgit@ltc189.sdl.hitachi.co.jp> <20120605131031.GF13495@aftab.osrc.amd.com>
In-Reply-To: <20120605131031.GF13495@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 09:10 PM, Borislav Petkov wrote:
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
>
> We already have an ftrace and perf ring buffer, can't you use one of those?

Not to mention virtio :-)

Why not just make a virtio device for this kind of thing?

Regards,

Anthony Liguori

>

