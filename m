Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab1JGMAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:00:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37065 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759897Ab1JGMAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:00:08 -0400
MIME-Version: 1.0
In-Reply-To: <20111007111831.GA5472@nameofcomputer>
References: <20111007111831.GA5472@nameofcomputer>
Date: Fri, 7 Oct 2011 07:54:24 -0400
Message-ID: <CAMzpN2j5sYh9MNsfwvr+R7YdaGy1y13ZHh2fvhe0jQiYkT0fEg@mail.gmail.com>
Subject: Re: x86: gdt_page and debugging from gdb against /proc
From: Brian Gerst <brgerst@gmail.com>
To: 33user@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 7:18 AM, myname <33user@gmail.com> wrote:
> in kernel/cpu/kernel/common.c, the initialization for the gdt_table symbol is like the following:
>
>        [GDT_ENTRY_KERNEL_CS]           = GDT_ENTRY_INIT(0xc09a, 0, 0xfffff),
>        [GDT_ENTRY_KERNEL_DS]           = GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
>        [GDT_ENTRY_DEFAULT_USER_CS]     = GDT_ENTRY_INIT(0xc0fa, 0, 0xfffff),
>        [GDT_ENTRY_DEFAULT_USER_DS]     = GDT_ENTRY_INIT(0xc0f2, 0, 0xfffff),
>
>        so, that the gtd_page[12] should have base = 0, and limit = 0xffffff, and so on for the next 3 slots in the array.
>
> now if i do: `sudo gdb -q ~/linux-3.0.3/vmlinux /proc/kcore' and in gdb ask for the command p/t gdt_table, i get, which obviously if you check for base and limit in member 12, 13 and so on, doesn't fit the above description. why?

gdt_page is a per-cpu variable, so you are looking at the original
location in init mem that has been overwritten with other data.

--
Brian Gerst
