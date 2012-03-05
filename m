Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab2CEUNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:13:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36730 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab2CEUNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:13:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.43.134.199 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120305120427.2d11d30e.akpm@linux-foundation.org>
References: <1330977506.1589.59.camel@lappy> <20120305120427.2d11d30e.akpm@linux-foundation.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 5 Mar 2012 22:13:11 +0200
Message-ID: <CA+1xoqdJLpzDi5GnqQ-4SD1rFv_XzecC2k2A-XYwp_HvuG=HGg@mail.gmail.com>
Subject: Re: OOM killer even when not overcommiting
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 10:04 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 05 Mar 2012 21:58:26 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
>
>> Hi all,
>
>> I assumed that when setting overcommit_memory=2 and
>> overcommit_ratio<100 that the OOM killer won't ever get invoked (since
>> we're not overcommiting memory), but it looks like I'm mistaken since
>> apparently a simple mmap from userspace will trigger the OOM killer if
>> it requests more memory than available.
>>
>> Is it how it's supposed to work?  Why does it resort to OOM killing
>> instead of just failing the allocation?
>>
>> Here is the dump I get when the OOM kicks in:
>>
>> ...
>>
>> [ 3108.730350]  [<ffffffff81198e4a>] mlock_vma_pages_range+0x9a/0xa0
>> [ 3108.734486]  [<ffffffff8119b75b>] mmap_region+0x28b/0x510
>> ...
>
> The vma is mlocked for some reason - presumably the app is using
> mlockall() or mlock()?  So the kernel is trying to instantiate all the
> pages at mmap() time.

The app may have used mlock(), but there is no swap space on the
machine (it's also a KVM guest), so it should matter, no?

Regardless, why doesn't it result in mmap() failing quietly, instead
of kicking in the OOM killer to kill the entire process?
