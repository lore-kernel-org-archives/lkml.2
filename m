Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab2IES5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:57:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39164 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2IES5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGXQ9+5uEvq-Pfxt=zZLWR3ZmR1WPeN=pzdzQVjHWrd0g@mail.gmail.com>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
	<1346823991-22911-15-git-send-email-yinghai@kernel.org>
	<CAOJsxLGXQ9+5uEvq-Pfxt=zZLWR3ZmR1WPeN=pzdzQVjHWrd0g@mail.gmail.com>
Date: Wed, 5 Sep 2012 11:57:16 -0700
X-Google-Sender-Auth: 54mBX1g48dFm6mLhkCzgXE6fHvU
Message-ID: <CAE9FiQWTRndGpRDDfiB4RqRPC6sEt252P+QnjPd0+sH8k3YBwg@mail.gmail.com>
Subject: Re: [PATCH -v3 14/14] x86, mm: Map ISA area with connected ram range
 at the same time
From: Yinghai Lu <yinghai@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 1:02 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> How significant is the speed gain? The "isa_done" flag makes code flow
> more difficult to follow.

Not really much.

when booting system:
memmap=16m$128m memmap=16m$512m memmap=16m$256m memmap=16m$768m memmap=16m$1024m

with the patch
[    0.000000] init_memory_mapping: [mem 0x00000000-0x07ffffff]
[    0.000000]  [mem 0x00000000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x09000000-0x0fffffff]
[    0.000000]  [mem 0x09000000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11000000-0x1fffffff]
[    0.000000]  [mem 0x11000000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x21000000-0x2fffffff]
[    0.000000]  [mem 0x21000000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x31000000-0x3fffffff]
[    0.000000]  [mem 0x31000000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x41000000-0x7fffdfff]
[    0.000000]  [mem 0x41000000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k


otherwise will have

[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x09000000-0x0fffffff]
[    0.000000]  [mem 0x09000000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11000000-0x1fffffff]
[    0.000000]  [mem 0x11000000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x21000000-0x2fffffff]
[    0.000000]  [mem 0x21000000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x31000000-0x3fffffff]
[    0.000000]  [mem 0x31000000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x41000000-0x7fffdfff]
[    0.000000]  [mem 0x41000000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
