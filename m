Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2CZKcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:32:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39635 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab2CZKcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com>
	<65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
	<CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
Date: Mon, 26 Mar 2012 18:32:00 +0800
Message-ID: <CAM_iQpXvzG8=1xrJGcwr2LYVuY561N6rwDk2YtgZHQ6PX4+NAw@mail.gmail.com>
Subject: Re: crash dump memory reservation regression
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: CAI Qian <caiqian@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 1:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sun, Mar 11, 2012 at 8:00 PM, CAI Qian <caiqian@redhat.com> wrote:
>> commit 3661ca66a42e306aaf53246fb75aec1ea01be0f0
>> x86, memblock: Fix crashkernel allocation
>>
>> introduced a regression that crashkernel=512M
>> according to bisecting will fail like this,
>>
>> crashkernel reservation failed - No suitable area found.
>> The full dmesg can be found here.
>>
>> http://people.redhat.com/qcai/dmesg.bad
>
> The reason is: we put pagetable for [0,2g) just blow 512M.
>
> Later we have other patches that will put pagetable for [0,2g) just
> below 2g. even at that time we only can access 512M, because we use
> early_ioremap to access page table.
>
> But that good_end part get reverted in following because it cause s4
> resume fail.
>
> So there will be pagetable around just below 512M again. So you have
> no chance to get 512M below 768M.
>
> Solution will be:
> 1.  remove the good_end setting for 64 bit again. and root cause S4 resume.
> 2.  get page low?
> 3.  fix kdump, and make kdump could take two ranges, one is small
> segment below 512M, other part could be more than 4G.

Is increasing CRASH_KERNEL_ADDR_MAX a 4th solution? I know we need
to fix kexec-tools too, but we will get more benefits...
