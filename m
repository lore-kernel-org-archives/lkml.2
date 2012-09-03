Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2ICFnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:43:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59565 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2ICFnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-13-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-13-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:43:10 +0300
X-Google-Sender-Auth: JUQzp83fbzecCf_SIDdB6Y06-L8
Message-ID: <CAOJsxLEb8=sRv91gSZkh9MD4oXatt_iWHPeFMchP4LfJy80ycg@mail.gmail.com>
Subject: Re: [PATCH -v2 12/13] x86, mm: Use func pointer to table size
 calculation and mapping.
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> +static void __init with_all_ram_ranges(
> +                       void (*work_fn)(unsigned long, unsigned long, void *),
> +                       void *data)

> +static void __init size_work_fn(unsigned long start, unsigned long end, void *data)

> +static void __init mapping_work_fn(unsigned long start, unsigned long end,
> +                                        void *data)

So I passionately hate the naming convention. How about something
similar to mm/pagewalk.c:

  s/with_all_ram_ranges/walk_ram_ranges/g

  s/size_work_fn/table_space_size/g

  s/mapping_work_fn/map_memory/g
