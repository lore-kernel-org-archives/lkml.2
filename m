Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2DTTa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:30:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36840 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2DTTaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120420191418.GA3569@merkur.ravnborg.org>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
	<20120420182907.GG32324@google.com>
	<20120420191418.GA3569@merkur.ravnborg.org>
Date: Fri, 20 Apr 2012 12:30:54 -0700
X-Google-Sender-Auth: s6trmde6eqDWi-R9ew1iCC993U4
Message-ID: <CAE9FiQU-M0yW_rwysq56zrZzift=PxgwioMmx8bMcJ5o20m2TQ@mail.gmail.com>
Subject: Re: Weirdness in __alloc_bootmem_node_high
From: Yinghai Lu <yinghai@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:14 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> I took a quick look at this.
> __alloc_bootmem_node_high() is used in mm/sparse.c - but only
> if SPARSEMEM_VMEMMAP is enabled.
>
> mips has this:
>
> config ARCH_SPARSEMEM_ENABLE
>        bool
>        select SPARSEMEM_STATIC
>
> So SPARSEMEM_VMEMMAP is not enabled.
>
> __alloc_bootmem_node_high() is used in mm/sparse-vmemmap.c which
> also depends on CONFIG_SPARSEMEM_VMEMMAP.
>
>
> So I really do not see the logic in __alloc_bootmem_node_high()
> being used anymore and it can be replaced by __alloc_bootmem_node()

Yes, you are right. __alloc_bootmem_node_high could be removed.

BTW, x86 is still the only one that use NO_BOOTMEM.

Are you working on making sparc to use NO_BOOTMEM?

Yinghai
